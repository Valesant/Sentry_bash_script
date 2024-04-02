#!/bin/bash

# Assuming apiKey and address are passed as command line arguments
apiKey=$1
address=$2

apiUrl="https://sentry.aleno.ai/suggestions?addresses=$address"

# Ensure jq and bc are installed
for tool in jq bc; do
    if ! command -v $tool &> /dev/null; then
        echo "$tool could not be found. Attempting to install $tool..."
        sudo apt-get update && sudo apt-get install -y $tool
    else
        echo "$tool is already installed. Continuing..."
    fi
done

response=$(curl -s -X GET "$apiUrl" -H "Authorization: $apiKey")

echo "Available metrics:"
echo "----------"
echo "On tokens in Wallet:"
# Tokens in Wallet
walletTokens=$(echo "$response" | jq -r '.data.metrics[] | select(.info.pool == null) | .info.token.address' | uniq)
for token in $walletTokens; do
    tokenMetrics=$(echo "$response" | jq --arg token "$token" -r '.data.metrics[] | select(.info.token.address == $token and .info.pool == null)')
    tokenName=$(echo "$tokenMetrics" | jq -r '.info.token.name' | uniq)
    usdAmount=$(echo "$response" | jq --arg token "$token" -r '.data.supportedAssets[] | select(.tokenAddress == $token) | .usdAmount' | jq -s 'add')
    metricKeys=$(echo "$tokenMetrics" | jq -r '.name')

    echo "$tokenName usdAmount: $usdAmount"
    echo "$metricKeys"
    echo "-"
done
echo "----------"

echo "Other available tokens:"

# Other available tokens in pools
poolTokens=$(echo "$response" | jq -r '.data.metrics[] | select(.info.pool != null) | .info.token.address' | uniq)
for token in $poolTokens; do
    if ! [[ " ${walletTokens[@]} " =~ " ${token} " ]]; then
        tokenMetrics=$(echo "$response" | jq --arg token "$token" -r '.data.metrics[] | select(.info.token.address == $token and .info.pool != null)')
        tokenName=$(echo "$tokenMetrics" | jq -r '.info.token.name' | uniq)
        usdAmount=$(echo "$response" | jq --arg token "$token" -r '.data.supportedAssets[] | select(.tokenAddress == $token) | .usdAmount' | jq -s 'add')
        metricKeys=$(echo "$tokenMetrics" | jq -r '.name')

        echo "$tokenName usdAmount: $usdAmount"
        echo "$metricKeys"
        echo "-"
    fi
done

echo "----------"
echo "On positions:"
# Pools and their metrics
pools=$(echo "$response" | jq -r '.data.metrics[] | select(.info.pool != null) | .info.pool.name' | uniq)
for pool in $pools; do
    echo "$pool:"
    poolMetrics=$(echo "$response" | jq --arg pool "$pool" -r '.data.metrics[] | select(.info.pool.name == $pool)')
    metricKeys=$(echo "$poolMetrics" | jq -r '.name')
    echo "$metricKeys"
    echo "-"
done
