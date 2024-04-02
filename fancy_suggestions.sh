#!/bin/bash

# Assuming apiKey and address are passed as command line arguments
apiKey=$1
address=$2
apiUrl="https://sentry.aleno.ai"

# Ensure jq and bc are installed
for tool in jq bc; do
    if ! command -v $tool &> /dev/null; then
        echo "Attempting to install $tool..."
        sudo apt-get update && sudo apt-get install -y $tool
    fi
done

echo "Fetching data..."
suggestionsResponse=$(curl -s -X GET "$apiUrl/suggestions?addresses=$address" -H "Authorization: $apiKey")

# Tokens in Wallet
echo -e "\n🔒 \e[1mTokens in Your Wallet:\e[0m"
echo "-------------------------------"
walletTokens=$(echo "$suggestionsResponse" | jq -r '.data.metrics[] | select(.info.pool == null) | .info.token.address' | uniq)
for token in $walletTokens; do
    tokenName=$(echo "$suggestionsResponse" | jq -r --arg token "$token" '.data.metrics[] | select(.info.token.address == $token and .info.pool == null) | .info.token.name' | head -1)
    usdAmount=$(echo "$suggestionsResponse" | jq -r --arg token "$token" '.data.supportedAssets[] | select(.tokenAddress == $token) | .usdAmount' | head -1)
    echo -e "\n💼 $tokenName (USD Amount: $usdAmount)"
    echo "$suggestionsResponse" | jq -r --arg token "$token" '.data.metrics[] | select(.info.token.address == $token and .info.pool == null) | "- \(.name)"'
done

# Other Relevant Tokens
echo -e "\n🌐 \e[1mOther Relevant Tokens:\e[0m"
echo "-------------------------------"
# Extract and filter unique pool token addresses not in wallet
poolTokenAddresses=$(echo "$suggestionsResponse" | jq -r '.data.metrics[] | select(.info.pool != null) | .info.pool.tokenAddresses[]' | sort | uniq)
uniqueTokenAddresses=$(echo "$poolTokenAddresses" | grep -v -f <(echo "$walletTokens" | sort | uniq))

if [ ! -z "$uniqueTokenAddresses" ]; then
    echo "$uniqueTokenAddresses" | while read address; do
        tokenName=$(curl -s -X GET "$apiUrl/tokens?addresses=$address" -H "accept: application/json" | jq -r '.data[].name')
        echo "- $tokenName"
    done
else
    echo "No unique tokens to process."
fi

# Pools and Associated Metrics
echo -e "\n🏊 \e[1mPools and Associated Metrics:\e[0m"
echo "-------------------------------"
poolAddresses=$(echo "$suggestionsResponse" | jq -r '.data.metrics[] | select(.info.pool != null) | .info.pool.address' | uniq)
for poolAddress in $poolAddresses; do
    poolName=$(echo "$suggestionsResponse" | jq -r --arg poolAddress "$poolAddress" '.data.metrics[] | select(.info.pool.address == $poolAddress) | .info.pool.name' | head -1)
    echo -e "\n🔄 $poolName"
    echo "$suggestionsResponse" | jq -r --arg poolAddress "$poolAddress" '.data.metrics[] | select(.info.pool.address == $poolAddress) | "- \(.name)"'
done

echo -e "\nPresentation data prepared. ✨"
