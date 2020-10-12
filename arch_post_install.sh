#!/bin/bash

#Configure zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Font and background download
curl -Lo ~/.wallpaper.jpg https://cdn.spacetelescope.org/archives/images/wallpaper4/heic1509a.jpg 
curl -Lo ~/.local/share/fonts/"JetBrains Mono Regular Nerd Font Complete Mono.ttf" --create-dirs https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Regular/complete/JetBrains%20Mono%20Regular%20Nerd%20Font%20Complete%20Mono.ttf 
fc-cache

# Download dotfiles
curl -Lo ~/dotfiles.zip https://github.com/iSkytran/dotfiles/archive/main.zip
unzip -o dotfiles.zip
cp -ar dotfiles-main/. ~/
rm -r dotfiles.zip dotfiles-main

# Make i3 start on login
printf "if [[ ! \$DISPLAY && \$XDG_VTNR -eq 1 ]]; then\n\texec startx\nfi\n" >> ~/.zprofile

# Install vim plugins
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +'PlugInstall --sync' +qa

# Generate ssh files
printf "Generating ssh files..."
ssh-keygen -t rsa -b 4096

# Final message
printf "Restart the computer to finish. Run nmtui to connect to internet. \
Sign into Google Chrome, VS Code, and Dropbox to sync preferences. \
Copy KeePass key file to computer and copy contents of public ssh key to GitHub.\
Delete /root/arch_install.sh and ~/arch_post_install."
