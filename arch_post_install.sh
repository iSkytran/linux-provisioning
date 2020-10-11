#!/bin/bash

#Configure zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
curl -L https://raw.githubusercontent.com/iSkytran/dotfiles/master/.p10k.zsh -o .p10k.zsh
curl -L https://raw.githubusercontent.com/iSkytran/dotfiles/master/.zshrc -o .zshrc

# Font and background download
curl -L https://cdn.spacetelescope.org/archives/images/wallpaper4/heic1509a.jpg -o ~/.wallpaper.jpg
curl -L https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Regular/complete/JetBrains%20Mono%20Regular%20Nerd%20Font%20Complete%20Mono.ttf -o ~/.local/share/fonts/"JetBrains Mono Regular Nerd Font Complete Mono.ttf" --create-dirs
fc-cache

# Download i3 dotfiles
curl -L https://raw.githubusercontent.com/iSkytran/dotfiles/master/.config/i3/config -o ~/.config/i3/config --create-dirs
curl -L https://raw.githubusercontent.com/iSkytran/dotfiles/master/.config/i3status/config -o ~/.config/i3status/config --create-dirs

# Download rofi config and terminator config
curl -L https://raw.githubusercontent.com/iSkytran/dotfiles/master/.config/rofi/config.rasi -o ~/.config/rofi/config.rasi --create-dirs
curl -L https://raw.githubusercontent.com/iSkytran/dotfiles/master/.config/rofi/myrofitheme.rasi -o ~/.config/rofi/myrofitheme.rasi --create-dirs
curl -L https://raw.githubusercontent.com/iSkytran/dotfiles/master/.config/terminator/config -o ~/.config/terminator/config --create-dirs

# Generate ssh files
printf "Generating ssh files..."
ssh-keygen -t rsa -b 4096

# Final message
printf ("Restart the computer to finish. Run nmtui to connect to internet. "
    "Sign into Google Chrome, VS Code, and Dropbox to sync preferences. "
    "Copy KeePass key file to computer and copy contents of public ssh key to GitHub."
    "Delete /root/arch_install.sh and ~/arch_post_install.")
