#!/bin/bash

# Define start and end dates
start_date="2024-01-01"
end_date="2024-04-01"

# Convert dates to seconds since the epoch
start_sec=$(date -d "$start_date" +%s)
end_sec=$(date -d "$end_date" +%s)

# Loop through each directory in the current directory
for dir in */ ; do
    # Remove the trailing slash
    dir=${dir%/}

    # Check if the directory name is in date format and in the range
    if [[ $dir =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        dir_sec=$(date -d "$dir" +%s)
        if (( dir_sec >= start_sec && dir_sec <= end_sec )); then
            echo "Deleting directory: $dir"
            rm -rf "$dir" # Uncomment this line to actually delete directories
        fi
    fi
done
