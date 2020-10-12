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
printf "Make 3 disk partitions, a 512M EFI System on /dev/sdX1, \
a linux swap 50% the size of computer's ram on /dev/sdX2, \
and a Linux filesystem using the rest of the disk on /dev/sdX3.\n\
Make note of the drive name (e.g. /dev/sda)\n\
Press enter to continue..."
read
cfdisk
read -p "Ender the drive name (default: /dev/sda): " drive_name
drive_name=${drive_name:-"/dev/sda"}
mkfs.fat -F32 ${drive_name}1
mkswap ${drive_name}2
mkfs.ext4 ${drive_name}3

# Set mirror
pacman -Syy
pacman -S reflector --noconfirm
reflector -c "US" -f 12 -l 10 -n 12 --save /etc/pacman.d/mirrorlist

# Install the system
mount ${drive_name}3 /mnt
swapon ${drive_name}2
mkdir /mnt/boot/efi
mount ${drive_name}1 /mnt/boot/efi
pacstrap /mnt base linux linux-firmware base-devel man-db man-pages texinfo grub efibootmgr networkmanager ufw curl git vim zsh tmux openssh python jdk-openjdk docker docker-compose

# Download part 2 of install
curl -Lo /mnt/root/arch_install_2.sh https://raw.githubusercontent.com/iSkytran/linux-install-scripts/main/arch_install_2.sh

# Generate fstab and enter mounted disk as root
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt /bin/sh /root/arch_install_2.sh

# Clean up part 2
rm /mnt/root/arch_install_2.sh
