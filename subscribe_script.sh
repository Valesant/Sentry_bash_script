#!/bin/bash

# Assuming apiKey and address are passed as command line arguments
apiKey=$1
address=$2

apiUrl="https://sentry.aleno.ai"

# Check and install jq if necessary
if ! command -v jq &> /dev/null; then
    echo "jq could not be found. Attempting to install jq..."
    sudo apt-get update
    sudo apt-get install -y jq
    echo "jq installed successfully."
else
    echo "jq is already installed. Continuing..."
fi

# Check and install bc if necessary
if ! command -v bc &> /dev/null; then
    echo "bc could not be found. Attempting to install bc..."
    sudo apt-get update
    sudo apt-get install -y bc
    echo "bc installed successfully."
else
    echo "bc is already installed. Continuing..."
fi

response=$(curl -s -X GET "${apiUrl}/suggestions?addresses=${address}" -H "Authorization: ${apiKey}")

# Process tokens not in pools (Tokens in Wallet)
echo "Available metrics:"
echo ""
echo "Tokens in Wallet"
walletTokens=$(echo "$response" | jq -r '.data.metrics[] | select(.info.pool == null) | .info.token.address' | uniq)
for token in $walletTokens; do
    tokenData=$(echo "$response" | jq -r --arg address "$token" '.data.metrics[] | select(.info.token.address==$address and .info.pool == null)')
    tokenName=$(echo "$tokenData" | jq -r '.info.token.name' | uniq)
    usdAmount=$(echo "$response" | jq -r --arg address "$token" '.data.supportedAssets[] | select(.tokenAddress==$address) | .usdAmount')
    
    if [[ ! -z "$usdAmount" && "$usdAmount" != "null" ]]; then
        echo "$tokenName usdAmount: $usdAmount"
    else
        echo "$tokenName is unsupported"
    fi
    
    echo "$tokenData" | jq -r '.name' | uniq
done
echo "---"

# Process Other available tokens in pools
echo "Other available tokens"
poolTokens=$(echo "$response" | jq -r '.data.metrics[] | select(.info.pool != null) | .info.token.address' | uniq)
for token in $poolTokens; do
    if [[ ! " ${walletTokens[@]} " =~ " ${token} " ]]; then
        tokenData=$(echo "$response" | jq -r --arg address "$token" '.data.metrics[] | select(.info.token.address==$address and .info.pool != null)')
        tokenName=$(echo "$tokenData" | jq -r '.info.token.name' | uniq)
        usdAmount=$(echo "$response" | jq -r --arg address "$token" '.data.supportedAssets[] | select(.tokenAddress==$address) | .usdAmount')
        
        if [[ ! -z "$usdAmount" && "$usdAmount" != "null" ]]; then
            echo "$tokenName usdAmount: $usdAmount"
        else
            echo "$tokenName is unsupported"
        fi
        
        echo "$tokenData" | jq -r '.name' | uniq
        echo "---"
    fi
done
