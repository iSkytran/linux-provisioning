$!/bin/bash

# Ensure in home directory
cd ~

# Install python 3
sudo apt update
sudo apt install git python3 python3-venv python3-pip -y

# Install pip packages
python3 -m pip install --user pipx
python3 -m pipx ensurepath
python3 -m pipx install ansible-base

# Clone provisioning repository
git clone https://github.com/iSkytran/linux-provisioning.git
