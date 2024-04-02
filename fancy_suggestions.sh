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

# Fetch suggestions
suggestionsResponse=$(curl -s -X GET "$apiUrl/suggestions?addresses=$address" -H "Authorization: $apiKey")

# Fetch tokens directly in the wallet
echo "Available metrics:"
echo "----------"
echo "On tokens in Wallet:"
walletTokens=$(echo "$suggestionsResponse" | jq -r '.data.metrics[] | select(.info.pool == null) | .info.token.address' | uniq)
for token in $walletTokens; do
    tokenMetrics=$(echo "$suggestionsResponse" | jq --arg token "$token" -r '.data.metrics[] | select(.info.token.address == $token and .info.pool == null)')
    tokenName=$(echo "$tokenMetrics" | jq -r '.info.token.name' | uniq)
    metricKeys=$(echo "$tokenMetrics" | jq -r '.name' | paste -sd ";" -)

    echo "$tokenName"
    echo "$metricKeys" | tr ';' '\n'
    echo "-"
done

echo "----------"
echo "Other available tokens:"
# Construct a list of all unique pool token addresses not already listed
allPoolTokenAddresses=$(echo "$suggestionsResponse" | jq -r '.data.metrics[] | select(.info.pool != null) | .info.pool.tokenAddresses[]' | uniq)
for token in $allPoolTokenAddresses; do
    if ! [[ $walletTokens =~ $token ]]; then
        # Secondary API call for tokens details
        tokenDetails=$(curl -s -X GET "$apiUrl/tokens?addresses=$token" -H "accept: application/json")
        echo "$tokenDetails" | jq -r '.data[] | select(.isTracked == true) | "\(.name) (\(.symbol))\n\(.symbol) total supply\n\(.symbol) total tvl\n-"'
    fi
done

echo "----------"
echo "On positions:"
# Assuming pool names or addresses can be directly extracted and are unique
poolNames=$(echo "$suggestionsResponse" | jq -r '.data.metrics[] | select(.info.pool != null) | .info.pool.name' | uniq)
for poolName in $poolNames; do
    echo "$poolName:"
    poolMetrics=$(echo "$suggestionsResponse" | jq --arg poolName "$poolName" -r '.data.metrics[] | select(.info.pool.name == $poolName)')
    metricKeys=$(echo "$poolMetrics" | jq -r '.name')
    echo "$metricKeys"
    echo "-"
done
