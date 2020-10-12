#!/bin/bash

# Check for root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Enable Network Manager
systemctl enable NetworkManager.service

# Firewall setup
systemctl enable --now ufw.service
ufw default deny
ufw allow from 192.168.0.0/24
ufw limit ssh
ufw enable

# Docker setup
systemctl enable --now docker.service

# Install yay package manager
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -r yay
sed -i '/Color/s/^#//g' /etc/pacman.conf

# Upgrade system to make sure everything is up to date
yay -Syu

# Install graphics driver
graphics_type=""
while [[ $graphics_type == "" ]]
do
    printf "Choose graphics driver (intel, amd, nvidia): "
    read graphics_type
    case $graphics_type in
    "intel")
        yay -S xf86-video-intel --noconfirm
        ;;
    "amd")
        yay -S xf86-video-amdgpu --noconfirm
        ;;
    "nvidia")
        yay -S nvidia --noconfirm
        ;;
    *)
        printf "Invalid selection."
        graphics_type=""
        ;;
    esac
done

# Install user software
yay -S keepassxc visual-studio-code-bin google-chrome dropbox --noconfirm
yay -S vim-lightline-git vim-rainbow-parentheses-improved --noconfirm

# Install i3 and related software
yay -S xorg-server xorg-xinit xorg-xbacklight i3-gaps dmenu i3lock i3status picom feh terminator ranger rofi vlc pulseaudio-alsa pulsemixer nm-applet --noconfirm
printf "exec i3" >> /etc/X11/xinit/xinitrc

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
arch_post_install.sh can now be removed."
