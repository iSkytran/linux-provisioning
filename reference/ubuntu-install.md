# Ubuntu Install Reference

## Table of Contents

- [Ubuntu Install Reference](#ubuntu-install-reference)
  - [Table of Contents](#table-of-contents)
  - [Installing Ubuntu](#installing-ubuntu)
  - [Post Install](#post-install)
    - [Check for Updates](#check-for-updates)
    - [Set Timezone](#set-timezone)
    - [Connect to the Internet](#connect-to-the-internet)
    - [Install CLI Software](#install-cli-software)
    - [Install Docker and Docker-Compose](#install-docker-and-docker-compose)
    - [Generate SSH Files](#generate-ssh-files)
    - [Configure Git](#configure-git)
    - [Configure Zsh and Tmux](#configure-zsh-and-tmux)
    - [Configure Tmux](#configure-tmux)
    - [Configure Vim](#configure-vim)
    - [Install Desktop Software](#install-desktop-software)
    - [Install Window Manager or Desktop Environment](#install-window-manager-or-desktop-environment)
      - [GNOME](#gnome)
      - [KDE Plasma](#kde-plasma)
    - [Install Font](#install-font)
    - [Switch Scrolling to Natural Scrolling](#switch-scrolling-to-natural-scrolling)

## Installing Ubuntu

Installing Ubuntu or Ubuntu server should be straight forward through the installer GUI provided.

## Post Install

### Check for Updates

Updates package information and installs any package updates.

```sh
sudo apt update && sudo apt upgrade -y
```

### Set Timezone

Set the timezone to New York. Other timezones can be found through `timedatectl list-timezones`.

```sh
sudo timedatectl set-timezone "America/New_York"
```

### Connect to the Internet

```sh
nmtui
```

### Install CLI Software

Installs Git, Zsh, Python 3, pip, pipx, and Java.

```sh
sudo apt install git zsh python3 python3-venv python3-pip openjdk-14-jdk -y
python3 -m pip install --user pipx
python3 -m pipx ensurepath
```

### Install Docker and Docker-Compose

Install Docker and Docker-Compose if containers are desired.

```sh
sudo apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io
pipx install docker-compose
```

### Generate SSH Files

Once generated, the contents of `~/.ssh/id_rsa.pub` can be copied to GitHub for Git or to other computers for SSH.

```sh
ssh-keygen -t rsa -b 4096
```

### Configure Git

Set Git user name to myname where myname is the desired username and set Git email to myemail where myemail is the desired email address.

```sh
git config --global user.name "myname"
git config --global user.email "myemail"
```

### Configure Zsh and Tmux

Install Oh-My-Zsh, Oh-My-Zsh plugins, Powerlevel10k.

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

Copy in a preexisting `.zshrc` to the home folder and modify it so that the paths are correct if desired.

```sh
curl -Lo ~/.zshrc  https://raw.githubusercontent.com/iSkytran/dotfiles/main/Linux/.zshrc
curl -Lo ~/.p10k.zsh https://raw.githubusercontent.com/iSkytran/dotfiles/main/Linux/.p10k.zsh
```

### Configure Tmux

Install Oh My Tmux.

```sh
git clone https://github.com/gpakosz/.tmux.git
ln -s -f .tmux/.tmux.conf
```

Copy in a preexisting `.tmux.conf.local` to the home folder or run the following command for default config.

```sh
cp .tmux/.tmux.conf.local .
```

OR

```sh
curl -Lo ~/.tmux.conf.local https://raw.githubusercontent.com/iSkytran/dotfiles/main/Linux/.tmux.conf.local
```

### Configure Vim

Set Vim as default editor and install Vim-Plug

```sh
sudo update-alternatives --config editor
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

Copy in a preexisting `.vimrc` to the home folder and run the following command for plugins if desired.

```sh
curl -Lo ~/.vimrc https://raw.githubusercontent.com/iSkytran/dotfiles/main/Linux/.vimrc
vim +'PlugInstall --sync' +qa
```

### Install Desktop Software

Some desktop software to install if desired. Copy in relevant files for usage or sign in to relevant software afterwards.

```sh
wget https://go.microsoft.com/fwlink/?LinkID=760868 && \
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install keepassxc ./code_1.51.0-1604600753_amd64 ./google-chrome-stable_current_amd64.deb  -y
rm ./code_1.51.0-1604600753_amd64 ./google-chrome-stable_current_amd64.deb
```

### Install Window Manager or Desktop Environment

Install a desktop if not included and copy in relevant configuration files as desired.

#### GNOME

```sh
sudo apt-get install ubuntu-desktop -y
```

#### KDE Plasma

```sh
sudo apt install kde-standard -y
```

### Install Font

Installs Fira Code NerdFont for the glyphs that it provides if using a window manager or desktop environment.

```sh
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts && \
    curl -fLo "Fira Code Bold Nerd Font Complete.ttf" https://git.io/JkJf7 && \
    curl -fLo "Fira Code Light Nerd Font Complete.ttf" https://git.io/JkJfH && \
    curl -fLo "Fira Code Medium Nerd Font Complete.ttf" https://git.io/JkJfF && \
    curl -fLo "Fira Code Regular Nerd Font Complete.ttf" https://git.io/JerhV && \
    curl -fLo "Fira Code Retina Nerd Font Complete.ttf" https://git.io/JkJfh && \
    curl -fLo "Fira Code SemiBold Nerd Font Complete.ttf" https://git.io/JkJJe && \
    cd ~
fc-cache
```

### Switch Scrolling to Natural Scrolling

To switch scrolling direction on touchpad, the desktop manager can be used to configure it or libinput must be edited.

```sh
sudoedit /usr/share/X11/xorg.conf.d/40-libinput.conf
```

For `Identifier "libinput pointer catchall"`, there must be a line that says `Option "NaturalScrolling" "true"`.
