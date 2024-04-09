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
echo -e "\n💼 \e[1mTokens in Your Wallet and Associated Metrics:\e[0m"
echo "-------------------------------"
walletTokens=$(echo "$suggestionsResponse" | jq -r '.data.metrics[] | select(.info.pool == null) | .info.token.address' | uniq)
for token in $walletTokens; do
    tokenName=$(echo "$suggestionsResponse" | jq -r --arg token "$token" '.data.metrics[] | select(.info.token.address == $token and .info.pool == null) | .info.token.name' | head -1)
    usdAmount=$(echo "$suggestionsResponse" | jq -r --arg token "$token" '.data.supportedAssets[] | select(.tokenAddress == $token) | .usdAmount' | head -1)
    echo -e "\n🪙 $tokenName (USD Amount: $usdAmount)"
    echo "$suggestionsResponse" | jq -r --arg token "$token" '.data.metrics[] | select(.info.token.address == $token and .info.pool == null) | "- \(.name)"'
done

# Other Relevant Tokens
echo -e "\n🌐 \e[1mOther Relevant Tokens to track:\e[0m"
echo "-------------------------------"

# Extract wallet tokens for exclusion
walletTokens=$(echo "$suggestionsResponse" | jq -r '.data.supportedAssets[] | .tokenAddress' | sort | uniq)

# Extract all token addresses involved in pools
poolTokenAddresses=$(echo "$suggestionsResponse" | jq -r '.data.metrics[] | select(.info.pool != null) | .info.pool.tokenAddresses[]' | sort | uniq)

# Determine unique token addresses not in wallet
uniqueTokenAddresses=$(echo "$poolTokenAddresses" | grep -vxF -f <(echo "$walletTokens") | tr '\n' ',' | sed 's/,$//')

if [ ! -z "$uniqueTokenAddresses" ]; then
    tokenDetails=$(curl -s -X GET "$apiUrl/tokens?chainId=eth&addresses=$uniqueTokenAddresses" -H "accept: application/json")

    # Display token information
    echo "$tokenDetails" | jq -r '.data[] | select(.isTracked == true) | "\n🪙 \(.name)\n- \(.symbol) total tvl\n- \(.symbol) total supply"'
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
