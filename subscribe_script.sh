#!/bin/bash

# Check for correct number of arguments
if [ "$#" -ne 8 ]; then
    echo "Usage: $0 <api_key> <user_name> <address> token_total_tvl_threshold=<value> token_total_supply_threshold=<value> pool_rate_threshold=<value> pool_tvl_threshold=<value>"
    exit 1
fi

apiKey=$1
userName=$2
address=$3
# Parsing named arguments for thresholds
shift 3 # Shift the first three arguments out of the way
declare -A thresholds
for arg in "$@"; do
  key=$(echo $arg | cut -f1 -d=)
  value=$(echo $arg | cut -f2 -d=)
  thresholds[$key]=$value
done

apiUrl="https://sentry.aleno.ai"

# Dependency check and user creation omitted for brevity

# Fetch suggestions
echo "Fetching metrics for address: $address"
response=$(curl -s -X GET "${apiUrl}/suggestions?addresses=${address}" -H "Authorization: ${apiKey}")

subscriptions=()

metrics=$(echo "$response" | jq -c '.data.metrics[]')
for metric in $metrics; do
    metricKey=$(echo "$metric" | jq -r '.key')
    metricType=$(echo "$metric" | jq -r '.type')
    
    # Determine the threshold based on metric type
    case $metricType in
        "token_total_tvl")
            threshold=${thresholds["token_total_tvl_threshold"]}
            ;;
        "token_total_supply")
            threshold=${thresholds["token_total_supply_threshold"]}
            ;;
        "pool_rate")
            threshold=${thresholds["pool_rate_threshold"]}
            ;;
        "pool_tvl")
            threshold=${thresholds["pool_tvl_threshold"]}
            ;;
        *)
            echo "Unknown metric type $metricType, skipping..."
            continue
            ;;
    esac

    # Prepare subscription
    subscription=$(jq -n --arg userId "$userId" --arg metricKey "$metricKey" --argjson threshold "$threshold" \
        '{userId: $userId, metricKey: $metricKey, threshold: $threshold}')
    subscriptions+=("$subscription")
done

# Convert array to JSON array string
subscriptionsJson=$(jq -n --argjson subscriptions "$(echo ${subscriptions[@]} | jq -s '.')" '{$subscriptions}')

# Create subscriptions
echo "Creating subscriptions..."
subscriptionResponse=$(curl -s -X POST "${apiUrl}/subscriptions" \
    -H 'accept: application/json' \
    -H "Authorization: ${apiKey}" \
    -d "$subscriptionsJson")

echo "Subscription response: $subscriptionResponse"
