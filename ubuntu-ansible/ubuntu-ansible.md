# Ubuntu Ansible Install

Use the bootstrap script to install Ansible and it's dependencies.

```sh
curl -sSL "https://raw.githubusercontent.com/iSkytran/linux-provisioning/main/ubuntu-ansible/ubuntu-bootstrap.sh" | bash -s
```

The Ansible playbook can now be run.

```sh
ansible-playbook ~/linux-provisioning/ubuntu-ansible/ubuntu-playbook.yml --ask-become-pass
```

Use the `wsl` switch if running in wsl.

```sh
ansible-playbook ~/linux-provisioning/ubuntu-ansible/ubuntu-playbook.yml -e "system=wsl" --ask-become-pass
```

To update the playbook, just pull the latest updates.

```sh
cd ~/linux-provisioning && git pull && cd ~
```
