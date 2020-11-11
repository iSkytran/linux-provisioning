$!/bin/bash

# Ensure in home directory
cd ~

# Install python 3
sudo apt update
sudo apt install git python3 python3-pip -y

# Install pip packages
python3 -m pip install --user pipx
python3 -m pipx ensurepath
pipx install ansible

# Clone provisioning repository
git clone https://github.com/iSkytran/linux-provisioning.git
