#!/bin/bash

# Checks for internet
while ! ping -q -c 1 -W 1 8.8.8.8 >> /dev/null
do
    printf "Waiting for internet..."
    sleep 1
done

# Update system clock
timedatectl set-ntp true

# Prompt user for partitions
printf ("Make 3 disk partitions, a 512M EFI System on /dev/sdX1, "
   "a 2G linux swap on /dev/sdX2, "
   "and a Linux filesystem using the rest of the disk on /dev/sdX3.\n"
   "Make note of the drive name (e.g. /dev/sda)"
   "Press enter to continue...")
read
cfdisk
read -p "Ender the drive name (default: /dev/sda): " drive_name
drive_name=${drive_name:-"/dev/sda"}
mkfs.fat -F32 ${drive_name}1
mkswap ${drive_name}2
mkfs.ext4 ${drive_name}3

# Set mirror
pacman -Syy
pacman -S reflector
reflector -c "US" -f 12 -l 10 -n 12 --save /etc/pacman.d/mirrorlist

# Install the system
mount ${drive_name}3 /mnt
pacstrap /mnt base linux linux-firmware base-devel man-db man-pages texinfo networkmanager ufw curl git vim zsh tmux openssh python jdk-openjdk docker docker-compose

# Generate fstab and enter mounted disk as root
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt

# Set time zone
read -p "Enter the time zone (default: America/New_York): " time_zone
time_zone=${time_zone:-"America/New_York"}
ln -sf /usr/share/zoneinfo/${time_zone} /etc/localtime
hwclock --systohc

# Setup locale
sed '/en_US.UTF-8 UTF-8/s/^#//g' /etc/locale.gen
locale-gen
printf "LANG=en_US.UTF-8" >> /etc/locale.conf

# Network configuration
read -p "Enter the hostname of the computer: " host_name
touch /etc/hosts
printf ("127.0.0.1\tlocalhost\n"
    "::1\tlocalhost\n127.0.1.1\t"
    "${host_name}.localdomain\t${host_name}") >> /etc/hosts
printf $host_name >> /etc/hostname
systemctl enable NetworkManager.service

# Firewall setup
systemctl enable --now ufw.service
ufw default deny
ufw allow from 192.168.0.0/24
ufw limit ssh
ufw enable

# Docker setup
systemctl enable --now docker.service

#Set root password
printf "Set root password..."
passwd

# Install bootloader
microcode_type=""
while (microcode_type == "")
do
    printf "Choose microcode updates (intel, amd, none): "
    read microcode_type
    case $microcode_type in
    "intel")
        pacman -S intel-ucode
        ;;
    "amd")
        pacman -S amd-ucode
        ;;
    "none")
        break
        ;;
    *)
        printf "Invalid selection."
        microcode_type=""
        ;;
    esac
done
pacman -S grub efibootmgr
mkdir /boot/efi
mount ${drive_name}1 /boot/efi
grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot/efi
grub-mkconfig -o /boot/grub/grub.cfg

# Add default user
read -p "Adding default user, enter username: " user_name
useradd -m -G wheel -s /usr/bin/zsh $user_name
printf "Set user password..."
passwd $user_name

# Install yay package manager
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -r yay
sed '/Color/s/^#//g' /etc/pacman.conf

# Upgrade system to make sure everything is up to date
yay -Syu

# Install graphics driver
graphics_type=""
while (graphics_type == "")
do
    printf "Choose graphics driver (intel, amd, nvidia): "
    read graphics_type
    case $graphics_type in
    "intel")
        yay -S xf86-video-intel
        ;;
    "amd")
        yay -S xf86-video-amdgpu
        ;;
    "nvidia")
        yay -S nvidia
        ;;
    *)
        printf "Invalid selection."
        graphics_type=""
        ;;
    esac
done

# Install user software
yay -S keepassxc visual-studio-code-bin google-chrome dropbox
yay -S vim-lightline-git vim-rainbow-parentheses-improved

# Install i3 and related software
yay -S xorg-server xorg-xinit xorg-xbacklight i3-gaps dmenu i3lock i3status picom feh terminator ranger rofi vlc pulseaudio-alsa pulsemixer nm-applet
printf "exec i3" >> /etc/X11/xinit/xinitrc

# Download post install script
curl -Lo /home/${user_name}/arch_post_install.sh https://raw.githubusercontent.com/iSkytran/linux-install-scripts/main/arch_post_install.sh
chmod a+x /home/${user_name}/arch_post_install.sh

# Switch to default user
printf "Switching to default user..."
su -c /home/${user_name}/arch_post_install.sh $user_name
