#!/bin/bash

# Check if the script is run as root
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

# Username to be granted passwordless sudo access
USERNAME="worker"

# Check if the user exists
if ! id "$USERNAME" &>/dev/null; then
  echo "User $USERNAME does not exist"
  exit 1
fi

# File to be modified
SUDOERS_FILE="/etc/sudoers"

# Backup the original sudoers file
cp $SUDOERS_FILE ${SUDOERS_FILE}.bak

# Check if the user already has passwordless sudo
if grep -q "$USERNAME ALL=(ALL) NOPASSWD: ALL" $SUDOERS_FILE; then
  echo "User $USERNAME already has passwordless sudo access."
else
  # Add passwordless sudo access for the user
  echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" >>$SUDOERS_FILE
  echo "Passwordless sudo access granted to $USERNAME."
fi
