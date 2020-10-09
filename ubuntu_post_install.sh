#!/bin/bash

# Setup apt
sudo apt update
sudo apt upgrade -y

# Install basic software
sudo apt install git zsh kde-standard -y
sudo snap install code --classic
sudo snap install keepassxc
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb -y
rm ./google-chrome-stable_current_amd64.deb

# Set time zone
sudo timedatectl set-timezone "America/New_York"

# Zsh configuration
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
curl -L https://raw.githubusercontent.com/iSkytran/dotfiles/master/.p10k.zsh -o .p10k.zsh
curl -L https://raw.githubusercontent.com/iSkytran/dotfiles/master/.zshrc -o .zshrc

# Generate ssh
ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa <<<y 2>&1 >/dev/null

# Install docker and docker-compose
sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo groupadd docker
sudo usermod -aG docker $USER
read -s -p "Enter github personal access token: "  CR_PAT
printf "\nexport CR_PAT = $CR_PAT\necho \$CR_PAT | docker login ghcr.io -u iskytran --password-stdin > /dev/null 2>&1\n" >> .zshrc

# Install font
mkdir .fonts
curl -L https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Regular/complete/JetBrains%20Mono%20Regular%20Nerd%20Font%20Complete%20Mono.ttf -o .fonts/"JetBrains Mono Regular Nerd Font Complete Mono.ttf"
sudo fc-cache -f -v

# Post script tasks
echo "To finish up, reboot, login to vscode, login to chrome, copy keypass files, and copy ssh key to github."
