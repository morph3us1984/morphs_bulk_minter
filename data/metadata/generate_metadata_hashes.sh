#!/bin/bash
rm links_with_metadata_hashes.csv
touch links_with_metadata_hashes.csv
while IFS= read -r line; do
echo $line
filename=$(echo "$line" | cut -d "," -f 1)
echo $filename
link=$(echo "$line" | cut -d "," -f 2)
echo $link
hash_with_dash=$(curl "$link" | sha256sum )
hash=$(echo "$hash_with_dash" | cut -d " " -f 1)
echo "$filename,$link,$hash" >> links_with_metadata_hashes.csv
done < metadata_links.txt
