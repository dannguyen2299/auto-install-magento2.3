#!/usr/bin/env bash

while IFS= read -r line; do
  if [[ $line != "#"* && -n $line ]]; then
    key=$(echo "$line" | cut -d'=' -f1)
    value=$(echo "$line" | cut -d'=' -f2-)

    # Check key
    if [[ $key == "PUBLIC_KEY" ]]; then
      export PUBLIC_KEY="$value"
    elif [[ $key == "PRIVATE_KEY" ]]; then
      export PRIVATE_KEY="$value"
    elif [[ $key == "HOST_NAME" ]]; then
      export HOST_NAME="$value"
    elif [[ $key == "PASSWORD" ]]; then
      export PASSWORD="$value"
    fi
  fi
done < .env
