#!/bin/bash

# Check for correct number of arguments
if [ "$#" -ne 7 ]; then
    echo "Usage: $0 address userName apiKey token_total_tvl_threshold token_total_supply_threshold pool_rate_threshold pool_tvl_threshold"
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
    echo "jq could not be found. Attempting to install jq..."
    sudo apt-get update
    sudo apt-get install -y jq
    echo "jq installed successfully."
else
    echo "jq is already installed. Continuing..."
fi



# Initialize counter for metric subscriptions
metric_subscriptions_count=0

# Step 0: Create a user and get userId
echo "Creating user: $userName"
userResponse=$(curl -s -X POST "${apiUrl}/users" \
    -H 'accept: application/json' \
    -H "Authorization: ${apiKey}" \
    -H 'Content-Type: application/json' \
    -d "{\"users\": [{ \"userName\": \"$userName\" }]}")

userId=$(echo "$userResponse" | jq -r '.data[0].id')
echo "User created with userId: $userId"

if [ -z "$userId" ] || [ "$userId" == "null" ]; then
    echo "Failed to create user or extract userId."
    exit 1
fi


# Fetching suggestions for metrics to subscribe
echo "Fetching metrics for address: $address"
suggestionsResponse=$(curl -s -X GET "${apiUrl}/suggestions?addresses=${address}" -H "Authorization: ${apiKey}")

# Process metrics and unique tokens
subscriptions=()
processMetrics() {
    while read -r key type; do
        threshold=0
        case "$type" in
            "token_total_tvl")
                threshold=$token_total_tvl_threshold
                ;;
            "token_total_supply")
                threshold=$token_total_supply_threshold
                ;;
            "pool_tvl")
                threshold=$pool_tvl_threshold
                ;;
            "pool_rate")
                threshold=$pool_rate_threshold
                ;;
        esac
        subscriptions+=("{\"userId\": \"$userId\", \"metricKey\": \"$key\", \"threshold\": $threshold}")
    done < <(echo $suggestionsResponse | jq -r '.data.metrics[] | "\(.key) \(.type)"')
}

processUniqueTokens() {
    # Extract wallet tokens for exclusion
    walletTokens=$(echo "$suggestionsResponse" | jq -r '.data.supportedAssets[] | .tokenAddress' | sort | uniq)
    
    # Extract all token addresses involved in pools
    poolTokenAddresses=$(echo "$suggestionsResponse" | jq -r '.data.metrics[] | select(.info.pool != null) | .info.pool.tokenAddresses[]' | sort | uniq)
    
    # Determine unique token addresses not in wallet
    uniqueTokenAddresses=$(echo "$poolTokenAddresses" | grep -vxF -f <(echo "$walletTokens") | tr '\n' ' ')
    
    for address in $uniqueTokenAddresses; do
        # Subscribe to total tvl and total supply for each unique token
        subscriptions+=("{\"userId\": \"$userId\", \"metricKey\": \"eth_token_total_tvl_${address}\", \"threshold\": $token_total_tvl_threshold}")
        subscriptions+=("{\"userId\": \"$userId\", \"metricKey\": \"eth_token_total_supply_${address}\", \"threshold\": $token_total_supply_threshold}")
    done
}

# Process metrics and unique tokens to build subscriptions
processMetrics
processUniqueTokens

# Finalize subscriptions payload
subscriptions_payload=$(printf ",%s" "${subscriptions[@]}")
subscriptions_payload="[${subscriptions_payload:1}]"

# Debug print to verify payload structure
echo "Final Payload: $subscriptions_payload"

# Create subscriptions (ensure your API endpoint and method match your needs)
# Uncomment the following curl command to execute subscription
curl -X POST "${apiUrl}/subscriptions" -H "accept: application/json" -H "Authorization: ${apiKey}" -d "{\"subscriptions\": $subscriptions_payload}"
