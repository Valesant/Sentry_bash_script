#!/bin/bash

# Assuming apiKey, address, and threshold are passed as command line arguments
apiKey=$1
address=$2
threshold=$3

apiUrl="https://sentry.aleno.ai"
response=$(curl -s -X GET "${apiUrl}/suggestions?addresses=${address}" -H "Authorization: ${apiKey}")

# Ensure bc is installed
if ! command -v bc &> /dev/null; then
    echo "Error: bc (calculator) not found. Please install bc."
    exit 1
fi

# Process tokens (excluding those in pools)
echo "Available metrics:"
echo ""
echo "Tokens in Wallet"
tokens=$(echo "$response" | jq -r '.data.metrics[] | select(.info.pool == null) | .info.token.address' | uniq)
for token in $tokens; do
    tokenData=$(echo "$response" | jq -r --arg address "$token" '.data.metrics[] | select(.info.token.address==$address and .info.pool == null)')
    tokenName=$(echo "$tokenData" | jq -r '.info.token.name' | uniq)
    usdAmount=$(echo "$response" | jq -r --arg address "$token" '.data.supportedAssets[] | select(.tokenAddress==$address) | .usdAmount')
    
    # Check if the token is supported
    if [[ ! -z "$usdAmount" && "$usdAmount" != "null" ]]; then
        echo "$tokenName usdAmount: $usdAmount"
    else
        echo "$tokenName is unsupported"
    fi
    
    # Print available metrics for the token
    echo "$tokenData" | jq -r '.name' | uniq
    echo "---"
done

# Process pools
echo "Exposed Pools"
pools=$(echo "$response" | jq -r '.data.metrics[].info.pool.address' | uniq)
for pool in $pools; do
    if [[ "$pool" != "null" ]]; then
        poolData=$(echo "$response" | jq -r --arg address "$pool" '.data.metrics[] | select(.info.pool.address==$address)')
        poolName=$(echo "$poolData" | jq -r '.info.pool.name' | uniq)
        poolAddress=$(echo "$poolData" | jq -r '.info.pool.address' | uniq)
        usdAmounts=$(echo "$response" | jq -r --arg address "$pool" '.data.supportedPositions[] | select(.contractAddress==$address) | .usdAmount')
        totalUsdAmount=0
        for amount in $usdAmounts; do
            totalUsdAmount=$(echo "$totalUsdAmount + $amount" | bc)
        done
        
        echo "$poolName usdAmount: $totalUsdAmount"
        echo "$poolAddress"
        
        # Print available metrics for the pool
        echo "$poolData" | jq -r '.name' | uniq
        echo "-"
    fi
done

