#!/bin/bash

# Check if the script is run with an argument
if [ $# -eq 0 ]; then
  echo "Usage: $0 path/to/directory"
  exit 1
fi

# Define the input and output files
INPUT_FILE="$1/.scope"
OUTPUT_FILE="$1/.out_of_scope"
DOMAINS_FILE="$1/domains"
DOMAIN_INVENTORY_FILE="$1/.domain_inventory"

# Loop over each line in the scope file
while read line; do
    # Check if the line matches the pattern subdomain.domain.tld
    if [[ "$line" =~ ^[a-zA-Z0-9_-]+\.[a-zA-Z0-9_-]+\.[a-zA-Z0-9_-]+$ ]]; then
        # Output the line to the domains file
        echo "$line" >> "$DOMAINS_FILE"
    # Check if the line matches the pattern *.domain.tld
    elif [[ "$line" =~ ^\*\.([a-zA-Z0-9_-]+\.)+[a-zA-Z0-9_-]+$ ]]; then
        # Extract the domain name
        domain=$(echo "$line" | sed 's/^\*\.//')

        # Output the domain name to the domains and domain inventory files
        echo "$domain" >> "$DOMAINS_FILE"
        echo "$domain" >> "$DOMAIN_INVENTORY_FILE"
    fi
done < "$INPUT_FILE"

# Remove duplicates from the domains and domain inventory files
sort -u -o "$DOMAINS_FILE" "$DOMAINS_FILE"
sort -u -o "$DOMAIN_INVENTORY_FILE" "$DOMAIN_INVENTORY_FILE"

# Remove lines from the output file that also exist in the out of scope file
grep -vFf "$OUTPUT_FILE" "$DOMAINS_FILE" > "$DOMAINS_FILE.tmp"
mv "$DOMAINS_FILE.tmp" "$DOMAINS_FILE"
grep -vFf "$OUTPUT_FILE" "$DOMAIN_INVENTORY_FILE" > "$DOMAIN_INVENTORY_FILE.tmp"
mv "$DOMAIN_INVENTORY_FILE.tmp" "$DOMAIN_INVENTORY_FILE"
