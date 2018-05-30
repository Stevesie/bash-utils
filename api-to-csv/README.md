# API to CSV

You have an API endpoint that returns a CSV of data, but it can't return the whole thing in one call - you need to paginate with a limit and offset.

This script will automatically loop through the endpoint given an initial URL with query parameters for `limit` and `offset` (configure these in the script if you want) and will incrementally append to a local CSV.
