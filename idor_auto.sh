#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0 [-m method] [-u url] [-e endpoint] [-w wordlist] [-o output]"
    echo "  -m  Set HTTP method: GET, POST, PUT, DELETE"
    echo "  -u  Target URL"
    echo "  -e  Endpoint to test"
    echo "  -w  Wordlist file"
    echo "  -o  Output file (optional)"
    exit 1
}

# Parse command-line options
while getopts "m:u:e:w:o:" opt; do
    case $opt in
        m) method=$OPTARG ;;
        u) url=$OPTARG ;;
        e) endpoint=$OPTARG ;;
        w) wordlist=$OPTARG ;;
        o) output=$OPTARG ;;
        *) usage ;;
    esac
done

# Check for mandatory options
if [ -z "$method" ] || [ -z "$url" ] || [ -z "$endpoint" ] || [ -z "$wordlist" ]; then
    usage
fi

# Validate URL
if [[ ! "$url" =~ ^https?:// ]]; then
    echo "Invalid URL. Please include http:// or https://"
    exit 1
fi

# Validate wordlist existence
if [ ! -f "$wordlist" ]; then
    echo "Wordlist file does not exist: $wordlist"
    exit 1
fi

# Run IDOR tests
echo "Testing for IDOR at $url$endpoint with IDs from $wordlist using $method method..."
while IFS= read -r id; do
  response=$(curl -s -o /dev/null -w "%{http_code}" -X "$method" "${url}${endpoint}/${id}")
  if [ "$response" -eq 200 ]; then
    result="IDOR found: ${url}${endpoint}/${id}"
    echo "$result"
    [ -n "$output" ] && echo "$result" >> "$output"
  fi
done < "$wordlist"

echo "IDOR testing completed."
