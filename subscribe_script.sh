#!/bin/bash

# Check for correct number of arguments
if [ "$#" -ne 7 ]; then
    echo "Usage: $0 address userName apiKey token_total_tvl_threshold token_total_supply_threshold pool_rate_threshold pool_tvl_threshold"
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



# Initialize counter for metric subscriptions
metric_subscriptions_count=0

# Step 0: Create a user and get userId
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


# Debug print the fetched metrics response
echo "Fetched metrics response: $metricsResponse"

# Initialize subscriptions payload
subscriptionsPayload="{\"subscriptions\":["

# Process each metric, determine the correct threshold, and add to the payload
echo "$metricsResponse" | jq -c '.data.metrics[]' | while read metric; do
    key=$(echo "$metric" | jq -r '.key')
    type=$(echo "$metric" | jq -r '.type')
    threshold=0

    # Select threshold based on metric type
    case "$type" in
        "token_total_tvl") threshold=$token_total_tvl_threshold ;;
        "token_total_supply") threshold=$token_total_supply_threshold ;;
        "pool_rate") threshold=$pool_rate_threshold ;;
        "pool_tvl") threshold=$pool_tvl_threshold ;;
    esac

    # Add subscription to payload
    subscriptionsPayload+="{\"userId\":\"$userId\",\"metricKey\":\"$key\",\"threshold\":$threshold},"

    # Debug print for each subscription added
    echo "Added subscription for $key with threshold $threshold"
done

# Close the JSON array for subscriptions payload
subscriptionsPayload="${subscriptionsPayload%,}]}"

# Debug print the final subscriptions payload
echo "Final subscriptions payload: $subscriptionsPayload"

# Step 3: Create subscriptions
echo "Creating subscriptions..."
subscriptionResponse=$(curl -s -X POST "$apiUrl/subscriptions" \
    -H 'Content-Type: application/json' \
    -H "Authorization: $apiKey" \
    -d "$subscriptionsPayload")

# Print subscription creation response
echo "Subscription creation response: $subscriptionResponse"
