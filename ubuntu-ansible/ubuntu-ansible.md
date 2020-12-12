# Ubuntu Ansible Install

Use the bootstrap script to install Ansible and it's dependencies.

```sh
curl -sSL "https://raw.githubusercontent.com/iSkytran/linux-provisioning/main/ubuntu-ansible/ubuntu-bootstrap.sh" | bash -s
```

The Ansible playbook can now be run.

```sh
cd ~/linux-provisioning/ubuntu-ansible && ansible-playbook ubuntu-playbook.yml -e "system=full" --ask-become-pass
```

Use the `vm` switch if running in a virtual machine or if docker is not desired.

```sh
cd ~/linux-provisioning/ubuntu-ansible && ansible-playbook ubuntu-playbook.yml -e "system=vm" --ask-become-pass
```

Use the `wsl` switch if running in wsl.

```sh
cd ~/linux-provisioning/ubuntu-ansible && ansible-playbook ubuntu-playbook.yml -e "system=wsl" --ask-become-pass
```

To update the playbook, just pull the latest updates.

```sh
cd ~/linux-provisioning && git pull && cd ~
```

The playbook can be removed after use.

```sh
cd ~ && rm -rf linux-provisioning
```
