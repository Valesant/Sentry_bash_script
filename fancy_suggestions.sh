#!/bin/bash

# Assuming apiKey and address are passed as command line arguments
apiKey=$1
address=$2
apiUrl="https://sentry.aleno.ai"

# Define colors
GREEN="\033[0;32m"
BLUE="\033[0;34m"
CYAN="\033[0;36m"
NC="\033[0m" # No Color

# Ensure jq and bc are installed
for tool in jq bc; do
    if ! command -v $tool &> /dev/null; then
        echo -e "${CYAN}$tool could not be found. Attempting to install $tool...${NC}"
        sudo apt-get update && sudo apt-get install -y $tool
    else
        echo -e "${GREEN}$tool is already installed. Continuing...${NC}"
    fi
done

suggestionsResponse=$(curl -s -X GET "$apiUrl/suggestions?addresses=$address" -H "Authorization: $apiKey")

# Tokens in Wallet
echo -e "${BLUE}Available metrics:${NC}"
echo "----------"
echo -e "${GREEN}On tokens in Wallet:${NC}"
walletTokens=$(echo "$suggestionsResponse" | jq -r '.data.metrics[] | select(.info.pool == null) | .info.token.address' | uniq)
for token in $walletTokens; do
    tokenMetrics=$(echo "$suggestionsResponse" | jq -r --arg token "$token" '.data.metrics[] | select(.info.token.address == $token and .info.pool == null)')
    tokenName=$(echo "$tokenMetrics" | jq -r '.info.token.name' | head -1)
    usdAmount=$(echo "$suggestionsResponse" | jq -r --arg token "$token" '.data.supportedAssets[] | select(.tokenAddress == $token) | .usdAmount' | head -1)
    echo -e "${BLUE}$tokenName${NC} usdAmount: ${CYAN}$usdAmount${NC}"
    echo "$tokenMetrics" | jq -r '"\(.name)"'
    echo "-"
done

echo "----------"
echo -e "${GREEN}Other available tokens:${NC}"
# Other available tokens
poolTokenAddresses=$(echo "$suggestionsResponse" | jq -r '.data.metrics[] | select(.info.pool != null) | .info.pool.tokenAddresses[]' | sort | uniq)
poolTokenAddresses=$(echo "$poolTokenAddresses" | grep -v -f <(echo "$walletTokens" | sort | uniq))

# Fetch details for unique tokens not in wallet in a single request
if [ ! -z "$poolTokenAddresses" ]; then
    tokenAddressesString=$(echo $poolTokenAddresses | tr '\n' ',' | sed 's/,$//')
    tokenDetails=$(curl -s -X GET "$apiUrl/tokens?addresses=$tokenAddressesString" -H "accept: application/json")
    echo "$tokenDetails" | jq -r '.data[] | select(.isTracked == true) | "- \(.name) (\(.symbol))"'
else
    echo "No unique tokens to process."
fi

echo "----------"
echo -e "${GREEN}On positions:${NC}"
# Group metrics by pool
poolAddresses=$(echo "$suggestionsResponse" | jq -r '.data.metrics[] | select(.info.pool != null) | .info.pool.address' | uniq)
for poolAddress in $poolAddresses; do
    poolMetrics=$(echo "$suggestionsResponse" | jq -r --arg poolAddress "$poolAddress" '.data.metrics[] | select(.info.pool.address == $poolAddress)')
    poolName=$(echo "$poolMetrics" | jq -r '.info.pool.name' | head -1)
    echo -e "${CYAN}$poolName:${NC}"
    echo "$poolMetrics" | jq -r '"\(.name)"'
    echo "-"
done
