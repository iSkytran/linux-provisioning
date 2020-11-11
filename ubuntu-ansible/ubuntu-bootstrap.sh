$!/bin/bash

# Install Ansible and its dependencies
sudo apt update
sudo apt install software-properties-common git python3 python3-pip -y
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y

# Clone provisioning repository
git clone git@github.com:iSkytran/linux-provisioning.git

# Run playbook
ansible-playbook ./linux-provisioning/ubuntu-ansible/ubuntu-playbook.yml
