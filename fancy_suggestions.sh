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
echo "Other available tokens:"
# Other available tokens in pools (Unique tokens not in wallet)
poolTokenAddresses=$(echo "$suggestionsResponse" | jq -r '.data.metrics[] | select(.info.pool != null) | .info.pool.tokenAddresses[]' | uniq | grep -v -f <(echo "$walletTokens"))
for token in $poolTokenAddresses; do
    tokenDetails=$(curl -s -X GET "$apiUrl/tokens?addresses=$token" -H "accept: application/json")
    echo "$tokenDetails" | jq -r '.data[] | select(.isTracked == true) | "\(.name) (\(.symbol))\n\(.symbol) total supply\n\(.symbol) total tvl\n-"'
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
