$!/bin/bash

# Ensure in home directory
cd ~

# Install python 3
sudo apt update
sudo apt install git ansible -y

# Clone provisioning repository
git clone https://github.com/iSkytran/linux-provisioning.git
