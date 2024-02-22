#!/usr/bin/env bash

source ./../.env
source ./get_env_script.sh
# Function to check if a command is available
command_exists() {
  command -v "$1" &> /dev/null
}

# Check if Docker is installed
if ! command_exists docker ; then
    echo "Docker is not installed on this machine. Installing Docker..."

    #Install Docker dependencies
    echo "$PASSWORD" | sudo -S apt update
    echo "$PASSWORD" | sudo -S apt install apt-transport-https ca-certificates curl software-properties-common -y

    # Install Docker
    echo "$PASSWORD" | sudo -S apt install docker-ce -y

    echo "Docker has been successfully installed."
fi

#Check if Docker Compose is installed
if ! command_exists docker-compose ; then
    echo "Docker Compose is not installed on this machine. Installing Docker Compose..."

    # Install Docker Compose
    echo "$PASSWORD" | sudo -S apt update
    echo "$PASSWORD" | sudo -S apt install docker-compose -y

    echo "Docker Compose has been successfully installed."
fi

echo "$PASSWORD" | sudo -S chmod 666 /var/run/docker. sock
