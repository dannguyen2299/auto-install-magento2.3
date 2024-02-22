#!/usr/bin/env bash

source get_env_script.sh

HOST_FILE="/etc/hosts"
TARGET_HOST="$HOST_NAME"

# Check if the value already exists in the hosts file
if grep -q "$TARGET_HOST" "$HOST_FILE"; then
  echo "$TARGET_HOST đã tồn tại trong $HOST_FILE"
else
  # Add the value to the line after 127.0.0.1
  echo "127.0.0.1 $TARGET_HOST" | sudo tee -a "$HOST_FILE" >/dev/null
fi
