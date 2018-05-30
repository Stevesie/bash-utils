#!/usr/bin/env bash

# Example Usage:
# ./api-to-csv.sh "https://stevesie.com/api/v1/workers/123/collection-results?limit=10&offset=0&taskCollectionId=123&format=csv&stream=true&token=123" ~/Desktop/all-items.csv

# This will keep polling the API (adjusting the offset) for a CSV until the API stops sending new rows, appending to the local file specified in the second argument.
# This expects the URL to contain "limit" and "offset" as query parameters, but feel free to tweak in this script below:

URL=$1
TARGET_CSV=$2

LIMIT_NAME="limit"
OFFSET_NAME="offset"

limit=$(expr "$URL" : ".*$LIMIT_NAME=\([0-9]*\)")
initial_offset=$(expr "$URL" : ".*$OFFSET_NAME=\([0-9]*\)")
current_offset=$((initial_offset + 0))

append_to_csv() {
	original_file_line_count=$(wc -l $TARGET_CSV)
    append_start=$(( current_offset == 0 ? 1 : 2 )) # skip the header if not the first request
    offset_url="${URL//$OFFSET_NAME=$initial_offset/$OFFSET_NAME=$current_offset}"
    echo $offset_url
    curl -k $offset_url | tail -n +$append_start >> $TARGET_CSV
    current_file_line_count=$(wc -l $TARGET_CSV)
    if [ "$current_file_line_count" != "$original_file_line_count" ]
    then
    	current_offset=$(($current_offset + $limit))
    	append_to_csv
    fi
}

append_to_csv
