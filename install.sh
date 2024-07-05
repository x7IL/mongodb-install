#!/bin/bash

# Install gnupg and curl
sudo apt-get install gnupg curl

# Add MongoDB public GPG key
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
   --dearmor

# Add MongoDB repository to the sources list
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

# Update the package list
sudo apt-get update

# Install MongoDB
sudo apt-get install -y mongodb-org

# Hold MongoDB packages at the current version
echo "mongodb-org hold" | sudo dpkg --set-selections
echo "mongodb-org-database hold" | sudo dpkg --set-selections
echo "mongodb-org-server hold" | sudo dpkg --set-selections
echo "mongodb-mongosh hold" | sudo dpkg --set-selections
echo "mongodb-org-mongos hold" | sudo dpkg --set-selections
echo "mongodb-org-tools hold" | sudo dpkg --set-selections

# Path to MongoDB configuration file
CONFIG_FILE="/etc/mongod.conf"

# Check if the configuration file exists
if [ -f "$CONFIG_FILE" ]; then
  # Backup the configuration file
  sudo cp "$CONFIG_FILE" "$CONFIG_FILE.bak"

  # Replace 127.0.0.1 with 0.0.0.0
  sudo sed -i 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/' "$CONFIG_FILE"

  # Print success message
  echo "Configuration file updated and backup created at $CONFIG_FILE.bak"
else
  # Print error message if the file doesn't exist
  echo "Configuration file $CONFIG_FILE does not exist."
fi

# Restart MongoDB to apply changes
sudo systemctl restart mongod
