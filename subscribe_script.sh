#!/bin/bash

# Function to print usage
print_usage() {
    echo "Usage: $0 address userName apiKey token_total_tvl_threshold token_total_supply_threshold pool_rate_threshold pool_tvl_threshold"
}

# Check for correct number of arguments
if [ "$#" -ne 7 ]; then
    print_usage
    exit 1
fi

# Assigning input arguments to variables
address="$1"
userName="$2"
apiKey="$3"
token_total_tvl_threshold="$4"
token_total_supply_threshold="$5"
pool_rate_threshold="$6"
pool_tvl_threshold="$7"
apiUrl="https://sentry.aleno.ai"

# Start timer
start_time=$(date +%s)

# Dependency check for jq
if ! command -v jq &> /dev/null
then
    echo "jq could not be found. Attempting to install jq..."
    sudo apt-get update
    sudo apt-get install -y jq
    echo "jq installed successfully."
else
    echo "jq is already installed. Continuing..."
fi

echo "Creating user: $userName"
userResponse=$(curl -s -X POST "${apiUrl}/users" \
    -H 'accept: application/json' \
    -H "Authorization: ${apiKey}" \
    -H 'Content-Type: application/json' \
    -d "{\"users\": [{ \"userName\": \"$userName\" }]}")

userId=$(echo "$userResponse" | jq -r '.data[0].id')
echo "User created with userId: $userId"

if [ -z "$userId" ] || [ "$userId" == "null" ]; then
    echo "Failed to create user or extract userId."
    exit 1
fi

echo "Fetching metrics for address: $address"
response=$(curl -s -X GET "${apiUrl}/suggestions?addresses=${address}" -H "Authorization: ${apiKey}")

subscriptions=$(echo "$response" | jq -c --arg userId "$userId" \
    --arg ttvt "$token_total_tvl_threshold" \
    --arg tts "$token_total_supply_threshold" \
    --arg prt "$pool_rate_threshold" \
    --arg ptvt "$pool_tvl_threshold" \
    '[.data.metrics[] | . + {userId: $userId, threshold: (if .type == "token_total_tvl" then $ttvt elif .type == "token_total_supply" then $tts elif .type == "pool_rate" then $prt elif .type == "pool_tvl" then $ptvt else "0" end)}]')

metric_subscriptions_count=$(echo "$subscriptions" | jq length)

echo "Subscribing to $metric_subscriptions_count metrics with specified thresholds"
subscriptionResponse=$(curl -s -X POST "${apiUrl}/subscriptions" \
         -H 'accept: application/json' \
         -H "Authorization: ${apiKey}" \
         -d "{\"subscriptions\": $subscriptions}")
echo "$subscriptionResponse" | jq '.'

# Execution time calculation
end_time=$(date +%s)
execution_time=$((end_time - start_time))

echo "Process completed."
echo "Execution time: $execution_time seconds."
echo "Number of metric keys subscribed: $metric_subscriptions_count."
echo "Reminder: The userId used for subscriptions was $userId."
