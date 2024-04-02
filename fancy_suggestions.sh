#!/bin/bash

# Assuming apiKey and address are passed as command line arguments
apiKey=$1
address=$2
apiUrl="https://sentry.aleno.ai"

# Ensure jq and bc are installed
for tool in jq bc; do
    if ! command -v $tool &> /dev/null; then
        echo "$tool could not be found. Attempting to install $tool..."
        sudo apt-get update && sudo apt-get install -y $tool
    else
        echo "$tool is already installed. Continuing..."
    fi
done

suggestionsResponse=$(curl -s -X GET "$apiUrl/suggestions?addresses=$address" -H "Authorization: $apiKey")

# Tokens in Wallet
echo "Available metrics:"
echo "----------"
echo "On tokens in Wallet:"
walletTokens=$(echo "$suggestionsResponse" | jq -r '.data.metrics[] | select(.info.pool == null) | .info.token.address' | uniq)
for token in $walletTokens; do
    tokenName=$(echo "$suggestionsResponse" | jq -r --arg token "$token" '.data.metrics[] | select(.info.token.address == $token) | .info.token.name' | head -1)
    usdAmount=$(echo "$suggestionsResponse" | jq -r --arg token "$token" '.data.supportedAssets[] | select(.tokenAddress == $token) | .usdAmount' | head -1)
    echo "$tokenName usdAmount: $usdAmount"
    echo "$suggestionsResponse" | jq -r --arg token "$token" '.data.metrics[] | select(.info.token.address == $token) | .name'
    echo "-"
done

echo "----------"
echo "Other available tokens AAAAA:"

# Extract all token addresses involved in pools
poolTokenAddresses=$(echo "$suggestionsResponse" | jq -r '.data.metrics[] | select(.info.pool != null) | .info.pool.tokenAddresses[]' | uniq)
echo "All Pool Token Addresses: $poolTokenAddresses"

# Filter out the wallet tokens from the pool token addresses
uniqueTokenAddresses=$(echo "$poolTokenAddresses" | grep -v -f <(printf "%s\n" $walletTokens) | uniq)
echo "Unique Token Addresses not in Wallet: $uniqueTokenAddresses"

# Fetch details for unique tokens not in wallet and ensure they are tracked
for token in $uniqueTokenAddresses; do
    echo "Processing token: $token"
    tokenDetails=$(curl -s -X GET "$apiUrl/tokens?addresses=$token" -H "accept: application/json")
    echo "Token Details for $token: $tokenDetails"

    isTracked=$(echo "$tokenDetails" | jq -r '.data[] | select(.isTracked == true)')
    if [ ! -z "$isTracked" ]; then
        echo "$isTracked" | jq -r '"\(.name) (\(.symbol))\n\(.symbol) total supply\n\(.symbol) total tvl\n-"'
    else
        echo "Token $token is not tracked or details are missing."
    fi
done



echo "----------"
echo "On positions:"
# Group metrics by pool
poolAddresses=$(echo "$suggestionsResponse" | jq -r '.data.metrics[] | select(.info.pool != null) | .info.pool.address' | uniq)
for poolAddress in $poolAddresses; do
    poolName=$(echo "$suggestionsResponse" | jq -r --arg poolAddress "$poolAddress" '.data.metrics[] | select(.info.pool.address == $poolAddress) | .info.pool.name' | head -1)
    echo "$poolName:"
    echo "$suggestionsResponse" | jq -r --arg poolAddress "$poolAddress" '.data.metrics[] | select(.info.pool.address == $poolAddress) | .name'
    echo "-"
done
