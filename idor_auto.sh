#!/bin/bash

# User input
echo "Enter target URL:"
read url

echo "Enter endpoint to test (e.g. /users/1):"
read endpoint

echo "Enter value to test for (e.g. 1):"
read value

echo "Enter wordlist location:"
read wordlist

# Test for IDOR
while read id; do
  response=$(curl -s -o /dev/null -w "%{http_code}" -X GET "${url}${endpoint}/${id}")
  if [ $response == 200 ]; then
    echo "IDOR found: ${url}${endpoint}/${id}"
  fi
done < $wordlist

echo "Done."
