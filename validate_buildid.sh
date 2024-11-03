#!/bin/sh

# This script checks if the local build ID of a dedicated server
# matches the remote build ID provided as an argument. It extracts the local build ID
# from the appmanifest file and compares it with the remote build ID. If they do not match,
# the script exits with an error message. If they match, it confirms the match.

# Extract the local build ID from the appmanifest file
local_buildid=$(grep -oP '"buildid".{1,}"(.*?)"' $HOME/serverfiles/steamapps/appmanifest_$1.acf | sed -n 's/.*"buildid".*"\(.*\)"/\1/p')

# Compare the local build ID with the remote build ID
if [ "$local_buildid" != "$2" ]; then
    echo "Build ID mismatch: local ($local_buildid) vs remote ($2)"
    exit 1
fi

# If the build IDs match, print a confirmation message
echo "Build IDs match: $local_buildid"
