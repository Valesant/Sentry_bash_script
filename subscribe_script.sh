#!/bin/bash

# Check for correct number of arguments
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 address userName apiKey threshold"
    exit 1
fi

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

# Assigning input arguments to variables
address="$1"
userName="$2"
apiKey="$3"
threshold="$4" # Threshold is now a parameter
apiUrl="https://sentry.aleno.ai"

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

echo "Fetching metrics for address: $address"
response=$(curl -s -X GET "${apiUrl}/suggestions?addresses=${address}" -H "Authorization: ${apiKey}")

if echo "$response" | jq -e '.data.metrics[]?' > /dev/null; then
    subscriptions=$(echo "$response" | jq -c '[.data.metrics[] | {userId: "'$userId'", metricKey: .key, threshold: '$threshold'}]')
    metric_subscriptions_count=$(echo "$subscriptions" | jq length)
    
    echo "Subscribing to $metric_subscriptions_count metrics with threshold: $threshold"
    subscriptionResponse=$(curl -s -X POST "${apiUrl}/subscriptions" \
             -H 'accept: application/json' \
             -H "Authorization: ${apiKey}" \
             -d "{\"subscriptions\": $subscriptions}")
    echo "$subscriptionResponse" | jq '.'
else
    echo "Error: Invalid or unexpected API response."
fi

# Execution time calculation
end_time=$(date +%s)
execution_time=$((end_time - start_time))

echo "Process completed."
echo "Execution time: $execution_time seconds."
echo "Number of metric keys subscribed: $metric_subscriptions_count."
echo "Reminder: The userId used for subscriptions was $userId."

