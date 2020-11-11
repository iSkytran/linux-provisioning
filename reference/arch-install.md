# Arch Install Commands

## Table of Contents

- [Arch Install Commands](#arch-install-commands)
  - [Table of Contents](#table-of-contents)
  - [Installing the Base System](#installing-the-base-system)
    - [Internet Setup](#internet-setup)
    - [Configure System Clock](#configure-system-clock)
    - [Partition and format the Disks](#partition-and-format-the-disks)
    - [Set Pacman Mirror](#set-pacman-mirror)
    - [Install the Arch System and Enable Swap](#install-the-arch-system-and-enable-swap)
    - [Generate fstab and change root into system](#generate-fstab-and-change-root-into-system)
    - [Set Timezone](#set-timezone)
    - [Setup Locale](#setup-locale)
    - [Configure Network](#configure-network)
    - [Install Bootloader and Relevant Microcode](#install-bootloader-and-relevant-microcode)
    - [Add Default User](#add-default-user)
    - [Reboot](#reboot)
  - [Post Install](#post-install)
    - [Connect to Internet](#connect-to-internet)
    - [Firewall Setup](#firewall-setup)
    - [Enable Docker](#enable-docker)
    - [Install Yay Package Manager](#install-yay-package-manager)
    - [Install a Graphics Driver](#install-a-graphics-driver)
    - [Generate SSH Files](#generate-ssh-files)
    - [Configure Git](#configure-git)
    - [Configure Zsh and Tmux](#configure-zsh-and-tmux)
    - [Configure Tmux](#configure-tmux)
    - [Configure Vim](#configure-vim)
    - [Install Desktop Software](#install-desktop-software)
    - [Install Window Manager or Desktop Environment](#install-window-manager-or-desktop-environment)
      - [GNOME](#gnome)
      - [i3-gaps](#i3-gaps)
      - [KDE Plasma](#kde-plasma)
    - [Install Font](#install-font)
    - [Switch Scrolling to Natural Scrolling](#switch-scrolling-to-natural-scrolling)

## Installing the Base System

### Internet Setup

Make sure internet is connected. If connected via ethernet, no further steps need to be taken. If using wifi, run `wifi-menu`.

### Configure System Clock

Ensure the system clock is accurate.

```sh
timedatectl set-ntp true
```

### Partition and format the Disks

For a basic partition, partition the disks into three partitions. Make the first partition an EFI partition 512 megabytes. Make the second partition a swap partition. This swap partition should be about 50% the size of the computer's ram. The third partition should be the size of the rest of the disk. Keep track of the drive name (e.g. /dev/sda).

```sh
cfdisk
mkfs.fat -F32 /dev/sdX1
mkswap /dev/sdX2
mkfs.ext4 /dev/sdX3
```

Make sure the X in sdX corresponds to the correct drive letter.

### Set Pacman Mirror

Install reflector package to set fastest mirror.

```sh
pacman -Syy
pacman -S relector --noconfirm
reflector -c "US" -f 12 -l 10 -n 12 --save /etc/pacman.d/mirrorlist
```

### Install the Arch System and Enable Swap

As mentioned before, make sure X in sdX corresponds to the correct drive letter. The packages listed in pacstrap can be changed.

```sh
mount /dev/sdX3 /mnt
swapon /dev/sdX2
pacstrap /mnt base linux linux-firmware base-devel \
    man-db man-pages texinfo \
    grub efibootmgr networkmanager \
    ufw curl git vim zsh tmux openssh zip unzip tar \
    python python-pip jdk-openjdk docker docker-compose
```

### Generate fstab and change root into system

```sh
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
```

### Set Timezone

Set timezone to New_York. `America/New_York` can be changed to another time zone. `timedatectl list-timezones` can be run to list available zones.

```sh
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
hwclock --systohc
```

### Setup Locale

Sets locale to American English UTF-8.

```sh
sed -i '/en_US.UTF-8 UTF-8/s/^#//g' /etc/locale.gen
locale-gen
printf "LANG=en_US.UTF-8" >> /etc/locale.conf
```

### Configure Network

Set hostname and hosts where myhostname is the hostname of the computer.

```sh
host_name="myhostname"
touch /etc/hosts
printf "127.0.0.1\tlocalhost\n\
    ::1\tlocalhost\n127.0.1.1\t\
    ${host_name}.localdomain\t${host_name}" >> /etc/hosts
printf $host_name >> /etc/hostname
```

### Install Bootloader and Relevant Microcode

Microcode is not requried, but if Intel microcode is desired, run `pacman -S intel-ucode --noconfirm`. If AMD microcode is desired, run `packman -S amd-ucode --noconfirm`. Now mount and install the bootloader. As mentioned before, make sure X in sdX corresponds to the correct drive letter.

```sh
mkdir /boot/efi
mount /dev/sdX1 /boot/efi
grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot/efi
grub-mkconfig -o /boot/grub/grub.cfg
```

### Add Default User

Add a user with sudo privilages where myusername is the desired username. The wheel group needs to be enabled for sudo to work properly.

```sh
useradd -m -G wheel -s /usr/bin/zsh myusername
passwd myusername
sed -i '/%wheel ALL=(ALL) ALL/s/^#//g' /etc/sudoers
```

### Reboot

The computer needs to be rebooted before proceeding.

```sh
shutdown -r now
```

## Post Install

### Connect to Internet

```sh
systemctl enable --now NetworkManager.service
nmtui
```

### Firewall Setup

Sets up a firewall if ufw is installed allowing incoming connections from local subnet, limits ssh, and denys other inbound connections.

```sh
systemctl enable --now ufw.service
sudo ufw default deny
sudo ufw allow from 192.168.0.0/24
sudo ufw limit ssh
sudo ufw enable
```

### Enable Docker

Run this if docker is installed.

```sh
systemctl enable --now docker.service
```

### Install Yay Package Manager

Installs yay and upgrades system to make sure everything is up to date.

```sh
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -sric --noconfirm
cd ..
rm -rf yay
sudo sed -i '/Color/s/^#//g' /etc/pacman.conf
yay -Syu
```

### Install a Graphics Driver

Run `yay -S xf86-video-intel --noconfirm` for Intel drivers. Run `yay -S xf86-video-amdgpu --noconfirm` for AMD drivers. Run `yay -S nvidia --noconfirm` for Nvidia drivers.

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

### Configure Vim

Install Vim-Plug.

```sh
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.
```

Copy in a preexisting `.vimrc` to the home folder and run the following command for plugins if desired.

```sh
vim +'PlugInstall --sync' +qa
```

### Install Desktop Software

Some desktop software to install if desired. Copy in relevant files for usage or sign in to relevant software afterwards.

```sh
yay -S keepassxc visual-studio-code-bin google-chrome dropbox --noconfirm
```

### Install Window Manager or Desktop Environment

Install and copy in relevant configuration files as desired.

#### GNOME

```sh
yay -S xorg gnome --noconfirm
systemctl enable --now gdm.service
```

#### i3-gaps

```sh
yay -S xorg-server xorg-xinit xorg-xbacklight i3-gaps dmenu i3lock i3status picom feh terminator ranger rofi vlc pulseaudio-alsa pulsemixer nm-applet --noconfirm
touch ~/.xinitrc
printf "exec i3" >> ~/.xinitrc
printf "if [[ ! \$DISPLAY && \$XDG_VTNR -eq 1 ]]; then\n\texec startx\nfi\n" >> ~/.zprofile
```

#### KDE Plasma

```sh
yay -S xorg plasma --noconfirm
systemctl enable --now sddm.service
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
