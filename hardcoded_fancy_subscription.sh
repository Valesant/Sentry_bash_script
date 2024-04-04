#!/bin/bash

# Assigning input arguments to variables
address="$1"
userName="$2"
apiKey="$3"
apiUrl="https://sentry.aleno.ai"

# Ensure jq and bc are installed
for tool in jq bc; do
    if ! command -v $tool &> /dev/null; then
        echo "Attempting to install $tool..."
        sudo apt-get update && sudo apt-get install -y $tool
    fi
done

# Begin script
echo -e "Fetching data...\n"
suggestionsResponse=$(curl -s -X GET "$apiUrl/suggestions?addresses=$address" -H "Authorization: $apiKey")

# Step 0: Create a user and get userId
userResponse=$(curl -s -X POST "${apiUrl}/users" \
    -H 'accept: application/json' \
    -H "Authorization: ${apiKey}" \
    -H 'Content-Type: application/json' \
    -d "{\"users\": [{ \"userName\": \"$userName\" }]}")

# Extract accountId from createUserResponse
accountId=$(echo "$userResponse" | jq -r '.data[0].accountId')
userNameResponse=$(echo "$userResponse" | jq -r '.data[0].userName')

# Begin script with a friendly message
echo "Fetching data..."
echo -e "\n🌟 \e[1mHello, $userNameResponse!\e[0m"
echo -e "🔑 Your account ID is: \e[1m$accountId\e[0m"
echo "---------------------------------\n"

# Tokens in Wallet
echo -e "💼 \e[1mYour Wallet Overview:\e[0m"
echo "---------------------------------"
walletTokens=$(echo "$suggestionsResponse" | jq -r '.data.metrics[] | select(.info.pool == null) | .info.token.address' | uniq)
for token in $walletTokens; do
    tokenName=$(echo "$suggestionsResponse" | jq -r --arg token "$token" '.data.metrics[] | select(.info.token.address == $token) | .info.token.name' | head -1)
    usdAmount=$(echo "$suggestionsResponse" | jq -r --arg token "$token" '.data.supportedAssets[] | select(.tokenAddress == $token) | .usdAmount' | head -1)
    tokenMetrics=$(echo "$suggestionsResponse" | jq -r --arg token "$token" '.data.metrics[] | select(.info.token.address == $token) | "\(.name)"')
    echo -e "\n🪙 $tokenName (USD Amount: $usdAmount)"
    echo "$tokenMetrics"
done

# Other Relevant Tokens
echo -e "\n🌐 \e[1mOther Relevant Tokens to track:\e[0m"
echo "-------------------------------"
# Extract all token addresses involved in pools
poolTokenAddresses=$(echo "$suggestionsResponse" | jq -r '.data.metrics[] | select(.info.pool != null) | .info.pool.tokenAddresses[]' | uniq)

# Filter out the wallet tokens from the pool token addresses and ensure unique addresses
uniqueTokenAddresses=$(echo "$poolTokenAddresses" | sort | uniq | grep -v -f <(echo "$walletTokens" | sort | uniq) | tr '\n' ',')

# Trim the trailing comma
uniqueTokenAddresses=${uniqueTokenAddresses%,}

# If there are any unique tokens not in wallet, make a single API call
if [ ! -z "$uniqueTokenAddresses" ]; then
    tokenDetails=$(curl -s -X GET "$apiUrl/tokens?addresses=$uniqueTokenAddresses" -H "accept: application/json")

    # For each tracked token, display its details
    echo "$tokenDetails" | jq -r '.data[] | select(.isTracked == true) | "🪙 \(.name)\n\(.symbol) total supply\n\(.symbol) total tvl\n"'
else
    echo "No unique tokens to process."
fi


# Pools and Associated Metrics
echo -e "\n🏊 \e[1mLiquidity Pools Overview:\e[0m"
echo "---------------------------------"
poolAddresses=$(echo "$suggestionsResponse" | jq -r '.data.metrics[] | select(.info.pool != null) | .info.pool.address' | uniq)
for poolAddress in $poolAddresses; do
    poolName=$(echo "$suggestionsResponse" | jq -r --arg poolAddress "$poolAddress" '.data.metrics[] | select(.info.pool.address == $poolAddress) | .info.pool.name' | head -1)
    poolMetrics=$(echo "$suggestionsResponse" | jq -r --arg poolAddress "$poolAddress" '.data.metrics[] | select(.info.pool.address == $poolAddress) | "\(.name)"')
    echo -e "\n🔄 $poolName"
    echo "$poolMetrics"
done

echo -e "\nPresentation data prepared. ✨"
