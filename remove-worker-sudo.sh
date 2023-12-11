#!/bin/bash

# Check if the script is run as root
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

# Username to be removed from passwordless sudo access
USERNAME="username"

# File to be modified
SUDOERS_FILE="/etc/sudoers"

# Backup the original sudoers file
cp $SUDOERS_FILE ${SUDOERS_FILE}.bak

# Remove the user's passwordless sudo access
sed -i "/$USERNAME ALL=(ALL) NOPASSWD: ALL/d" $SUDOERS_FILE

echo "Passwordless sudo access for $USERNAME has been removed, if it existed."

# Check the syntax of the modified sudoers file
visudo -c
if [ $? -ne 0 ]; then
  echo "Error in sudoers file syntax. Reverting changes."
  cp ${SUDOERS_FILE}.bak $SUDOERS_FILE
else
  echo "Changes applied successfully."
  rm ${SUDOERS_FILE}.bak
fi
