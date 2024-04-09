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

# Create user and get userId
echo "Creating user: $userName"
userResponse=$(curl -s -X POST "${apiUrl}/users" \
    -H 'accept: application/json' \
    -H "Authorization: Bearer ${apiKey}" \
    -H 'Content-Type: application/json' \
    -d "{\"users\": [{ \"userName\": \"$userName\" }]}")

userId=$(echo "$userResponse" | jq -r '.data[0].id')
echo "User created with userId: $userId"

# Handle failure to create user or extract userId
if [ -z "$userId" ] || [ "$userId" == "null" ]; then
    echo "Failed to create user or extract userId."
    exit 1
fi

# Fetching suggestions for metrics to subscribe
echo "Fetching metrics for address: $address"
response=$(curl -s -X GET "${apiUrl}/suggestions?addresses=${address}" -H "Authorization: Bearer ${apiKey}")

# Subscribing to metrics based on thresholds
echo "Preparing subscriptions..."
subscriptions=()
for row in $(echo "${response}" | jq -r '.data.metrics[] | @base64'); do
    _jq() {
     echo ${row} | base64 --decode | jq -r ${1}
    }

    metricKey=$(_jq '.key')
    metricType=$(_jq '.type')
    case $metricType in
        token_total_tvl)
            threshold=$token_total_tvl_threshold
            ;;
        token_total_supply)
            threshold=$token_total_supply_threshold
            ;;
        pool_rate)
            threshold=$pool_rate_threshold
            ;;
        pool_tvl)
            threshold=$pool_tvl_threshold
            ;;
        *)
            continue
            ;;
    esac

    # Append subscription to array
    subscriptions+=("{\"userId\":\"$userId\",\"metricKey\":\"$metricKey\",\"threshold\":$threshold}")
done

# Join array into a JSON array string
subscriptions_json=$(printf ",%s" "${subscriptions[@]}")
subscriptions_json="[${subscriptions_json:1}]"

# Create subscriptions
echo "Subscribing to metrics..."
subscriptionResponse=$(curl -s -X POST "${apiUrl}/subscriptions" \
         -H 'accept: application/json' \
         -H "Authorization: Bearer ${apiKey}" \
         -d "{\"subscriptions\": $subscriptions_json}")
echo "Subscription response: "
echo "$subscriptionResponse" | jq '.'

# Execution time calculation
end_time=$(date +%s)
execution_time=$((end_time - start_time))

echo "Process completed."
echo "Execution time: $execution_time seconds."
echo "Number of metric keys subscribed: ${#subscriptions[@]}."
echo "Reminder: The userId used for subscriptions was $userId."
