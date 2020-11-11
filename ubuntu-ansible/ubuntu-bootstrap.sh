$!/bin/bash

# Install Ansible and its dependencies
sudo apt update
sudo apt install ansible -y

# Clone provisioning repository
git clone https://github.com/iSkytran/linux-provisioning.git

# Run playbook
ansible-playbook ./linux-provisioning/ubuntu-ansible/ubuntu-playbook.yml
