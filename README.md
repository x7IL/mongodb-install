# MongoDB Installation Script

This script installs MongoDB on an Ubuntu system, configures it to allow remote connections, and holds the package versions to prevent automatic updates.

## Usage

1. Make the script executable:
    ```
    chmod +x install.sh
    ```

2. Run the script with superuser privileges:
    ```
    sudo ./install.sh
    ```

## Script Explanation

- **Install gnupg and curl:**
  ```bash
  sudo apt-get install gnupg curl
  ```

- **Add MongoDB public GPG key:**
  ```
  curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor
  ```

- **Add MongoDB repository to the sources list:**
  ```
  echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
  ```

- **Update the package list:**
  ```
  sudo apt-get update
  ```

- **Install MongoDB:**
  ```
  sudo apt-get install -y mongodb-org
  ```

- **Hold MongoDB packages at the current version:**
  ```
  echo "mongodb-org hold" | sudo dpkg --set-selections
  echo "mongodb-org-database hold" | sudo dpkg --set-selections
  echo "mongodb-org-server hold" | sudo dpkg --set-selections
  echo "mongodb-mongosh hold" | sudo dpkg --set-selections
  echo "mongodb-org-mongos hold" | sudo dpkg --set-selections
  echo "mongodb-org-tools hold" | sudo dpkg --set-selections
  ```

- **Backup and update MongoDB configuration file:**
  ```
  CONFIG_FILE="/etc/mongod.conf"

  if [ -f "$CONFIG_FILE" ]; then
    sudo cp "$CONFIG_FILE" "$CONFIG_FILE.bak"
    sudo sed -i 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/' "$CONFIG_FILE"
    echo "Configuration file updated and backup created at $CONFIG_FILE.bak"
  else
    echo "Configuration file $CONFIG_FILE does not exist."
  fi
  ```

- **Restart MongoDB to apply changes:**
  ```
  sudo systemctl restart mongod
  ```
