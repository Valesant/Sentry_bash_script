#!/bin/bash

# Check for correct number of arguments
if [ "$#" -ne 7 ]; then
    echo "🚫 Usage: $0 address userName apiKey token_total_tvl_threshold token_total_supply_threshold pool_rate_threshold pool_tvl_threshold"
    exit 1
fi

# Assigning input arguments to variables
address="$1"
userName="$2"
apiKey="$3"
token_total_tvl_threshold="$4"
token_total_supply_threshold="$5"
pool_rate_threshold="$6"
pool_tvl_threshold="$7"
apiUrl="https://sentry.aleno.ai"

# Start timer
start_time=$(date +%s)

# Dependency check for jq
if ! command -v jq &> /dev/null
then
    echo "⚙️ jq could not be found. Attempting to install jq..."
    sudo apt-get update
    sudo apt-get install -y jq
    echo "✅ jq installed successfully."
else
    echo "✅ jq is already installed. Continuing..."
fi

# Initialize counters for metric subscriptions
declare -A subscription_counts=(
    ["token_total_tvl"]=0
    ["token_total_supply"]=0
    ["pool_rate"]=0
    ["pool_tvl"]=0
)

# Step 0: Create a user and get userId
echo "👤 Creating user: $userName"
userResponse=$(curl -s -X POST "${apiUrl}/users" \
    -H 'accept: application/json' \
    -H "Authorization: ${apiKey}" \
    -H 'Content-Type: application/json' \
    -d "{\"users\": [{ \"userName\": \"$userName\" }]}")

userId=$(echo "$userResponse" | jq -r '.data[0].id')
echo "🆔 User created with userId: $userId"

if [ -z "$userId" ] || [ "$userId" == "null" ]; then
    echo "❌ Failed to create user or extract userId."
    exit 1
fi

# Fetching suggestions for metrics to subscribe
echo "🔍 Fetching metrics for address: $address"
suggestionsResponse=$(curl -s -X GET "${apiUrl}/suggestions?addresses=${address}" -H "Authorization: ${apiKey}")

# Process metrics and unique tokens
subscriptions=()
processMetrics() {
    while read -r key type; do
        threshold=0
        case "$type" in
            "token_total_tvl")
                threshold=$token_total_tvl_threshold
                subscription_counts["token_total_tvl"]=$((subscription_counts["token_total_tvl"]+1))
                ;;
            "token_total_supply")
                threshold=$token_total_supply_threshold
                subscription_counts["token_total_supply"]=$((subscription_counts["token_total_supply"]+1))
                ;;
            "pool_tvl")
                threshold=$pool_tvl_threshold
                subscription_counts["pool_tvl"]=$((subscription_counts["pool_tvl"]+1))
                ;;
            "pool_rate")
                threshold=$pool_rate_threshold
                subscription_counts["pool_rate"]=$((subscription_counts["pool_rate"]+1))
                ;;
        esac
        subscriptions+=("{\"userId\": \"$userId\", \"metricKey\": \"$key\", \"threshold\": $threshold}")
    done < <(echo $suggestionsResponse | jq -r '.data.metrics[] | "\(.key) \(.type)"')
}

processUniqueTokens() {
    echo "Processing unique tokens not in wallet..."

    # Extract wallet tokens for exclusion
    walletTokens=$(echo "$suggestionsResponse" | jq -r '.data.supportedAssets[] | .tokenAddress' | sort | uniq)

    # Extract all token addresses involved in pools
    poolTokenAddresses=$(echo "$suggestionsResponse" | jq -r '.data.metrics[] | select(.info.pool != null) | .info.pool.tokenAddresses[]' | sort | uniq)

    # Determine unique token addresses not in wallet
    uniqueTokenAddresses=$(echo "$poolTokenAddresses" | grep -vxF -f <(echo "$walletTokens") | tr '\n' ',' | sed 's/,$//')
    
# Check if there are unique tokens to process
    if [ ! -z "$uniqueTokenAddresses" ]; then
        echo "uniqueTokenAddresses: $uniqueTokenAddresses"

        # Fetch token details
        tokenDetails=$(curl -s -X GET "$apiUrl/tokens?chainId=eth&addresses=$uniqueTokenAddresses" -H "accept: application/json")
   
        echo "tokenDetails: $tokenDetails"


        # Extract token addresses with "isTracked" set to true
        trackedTokenAddresses=$(echo "$tokenDetails" | jq -r '.data[] | select(.isTracked == true) | .address')

        echo "trackedTokenAddresses: $trackedTokenAddresses"

        # Convert tracked token addresses to an array
        readarray -t trackedTokenAddressesArray <<< "$trackedTokenAddresses"

        echo "{trackedTokenAddressesArray[@]}:${trackedTokenAddressesArray[@]}"
        
        # Iterate over tracked token addresses array
        for tokenAddress in "${trackedTokenAddressesArray[@]}"; do
            if [ ! -z "$tokenAddress" ]; then
                # Subscribe to total TVL for each unique token
                subscriptions+=("{\"userId\": \"$userId\", \"metricKey\": \"eth_token_total_tvl_${tokenAddress}\", \"threshold\": $token_total_tvl_threshold}")
                subscription_counts["token_total_tvl"]=$((subscription_counts["token_total_tvl"]+1))
                
                # Subscribe to total supply for each unique token
                subscriptions+=("{\"userId\": \"$userId\", \"metricKey\": \"eth_token_total_supply_${tokenAddress}\", \"threshold\": $token_total_supply_threshold}")
                subscription_counts["token_total_supply"]=$((subscription_counts["token_total_supply"]+1))
                
                echo "Subscribed to total TVL and total supply metrics for $tokenAddress"
            fi
        done
    else
        echo "No unique tokens to process."
    fi
}

processMetrics
echo "subscriptions: $subscriptions"
echo "subscription_counts: $subscription_counts"

processUniqueTokens
echo "subscriptions: $subscriptions"
echo "subscription_counts: $subscription_counts"


# Finalize subscriptions payload
subscriptions_payload=$(printf ",%s" "${subscriptions[@]}")
subscriptions_payload="[${subscriptions_payload:1}]"

echo "Final Payload: $subscriptions_payload"

subscriptions_json=$(jq -n --argjson subs "$(printf "%s\n" "${subscriptions[@]}" | jq -s)" '$subs')

# Creating subscriptions
echo "📝 Creating subscriptions for user $userName..."
createSubscriptionsResponse=$(curl -s -X POST "${apiUrl}/subscriptions" -H "accept: application/json" -H "Authorization: ${apiKey}" -d "{\"subscriptions\": $subscriptions_json}")

subscriptionSuccess=$(echo "$createSubscriptionsResponse" | jq -r '.data | length')
if [ "$subscriptionSuccess" -gt 0 ]; then
    echo "✅ Successfully subscribed to $subscriptionSuccess metrics for address $address"
else
    echo "❌ Failed to create subscriptions. Please check your API key and network connectivity."
    echo "Response was: $createSubscriptionsResponse"
    exit 1
fi

# Execution time calculation
end_time=$(date +%s)
execution_time=$((end_time - start_time))
echo "⏱ Execution time: $execution_time seconds."

# Final summary
echo "📊 Summary:"
echo "-------------------------------"
echo "👤 User: $userName"
echo "🆔 User ID: $userId"
echo "📍 Address: $address"
echo "📈 Metrics Subscribed: $subscriptionSuccess"
echo "⏱ Execution Time: $execution_time seconds"
for type in "${!subscription_counts[@]}"; do
    echo "🔔 $type alerts: ${subscription_counts[$type]} (Threshold: ${!type}_threshold)"
done
