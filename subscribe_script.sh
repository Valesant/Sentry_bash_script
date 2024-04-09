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
declare -A thresholds=(
    ["token_total_tvl"]="$4"
    ["token_total_supply"]="$5"
    ["pool_rate"]="$6"
    ["pool_tvl"]="$7"
)
apiUrl="https://sentry.aleno.ai"

# Start timer
start_time=$(date +%s)

# Dependency check for jq
if ! command -v jq > /dev/null 2>&1
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

# Extracting unique tokens from pools that are not in the wallet
extractUniquePoolTokens() {
    # Extract wallet tokens for exclusion
    walletTokens=$(echo "$suggestionsResponse" | jq -r '.data.supportedAssets[] | .tokenAddress' | sort | uniq)

    # Extract all token addresses involved in pools
    poolTokenAddresses=$(echo "$suggestionsResponse" | jq -r '.data.metrics[] | select(.info.pool != null) | .info.pool.tokenAddresses[]' | sort | uniq)

    # Determine unique token addresses not in wallet
    uniqueTokenAddresses=$(echo "$poolTokenAddresses" | grep -vxF -f <(echo "$walletTokens") | tr '\n' ' ')

    echo "$uniqueTokenAddresses"
}

# Updated section to include "Other Relevant Tokens to track"
echo "🔄 Starting to process each supported and unique pool asset..."
processSupportedAndUniquePoolAssets() {
    supportedAssets=$(echo "$suggestionsResponse" | jq -c '.data.supportedAssets[]' | jq -r '.tokenAddress')
    uniquePoolTokens=$(extractUniquePoolTokens)
    combinedTokens="$supportedAssets $uniquePoolTokens"

    for tokenAddress in $combinedTokens; do
        echo "🪙 Processing Asset: $tokenAddress"
        # Subscribe to total tvl and total supply for each unique token and supported asset
        subscriptions+=("{\"userId\": \"$userId\", \"metricKey\": \"eth_token_total_tvl_${tokenAddress}\", \"threshold\": ${thresholds[token_total_tvl]} }")
        subscriptions+=("{\"userId\": \"$userId\", \"metricKey\": \"eth_token_total_supply_${tokenAddress}\", \"threshold\": ${thresholds[token_total_supply]} }")
    done
}

# Call the updated function to process both supported assets and unique pool tokens
processSupportedAndUniquePoolAssets

echo "📈 Subscriptions count after processing Supported Assets: ${#subscriptions[@]}"

# Continue with your script to finalize subscriptions_payload
subscriptions_payload=$(printf ",%s" "${subscriptions[@]}")
subscriptions_payload="[${subscriptions_payload:1}]"

# Debug print to verify payload structure
echo "Final Payload: $subscriptions_payload"

# Creating subscriptions
echo "📝 Creating subscriptions for user $userName..."
createSubscriptionsResponse=$(curl -s -X POST "${apiUrl}/subscriptions" -H "accept: application/json" -H "Authorization: ${apiKey}" -d "{\"subscriptions\": $subscriptions_payload}")

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
    echo "🔔 $type alerts: ${subscription_counts[$type]} alerts, threshold: ${thresholds[$type]}"
done
