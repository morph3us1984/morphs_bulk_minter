#!/bin/bash
set -x
rm links_with_hashes.csv
touch links_with_hashes.csv
while IFS= read -r line; do
filename=$(echo "$line" | cut -d "," -f 1)
link=$(echo "$line" | cut -d "," -f 2)
hash_with_dash=$(curl "$link" | sha256sum )
hash=$(echo "$hash_with_dash" | cut -d " " -f 1)
echo "$filename,$link,$hash" >> links_with_hashes.csv
done < links.txt
