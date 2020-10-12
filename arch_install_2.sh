#!/bin/bash

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
printf "127.0.0.1\tlocalhost\n\
    ::1\tlocalhost\n127.0.1.1\t\
    ${host_name}.localdomain\t${host_name}" >> /etc/hosts
printf $host_name >> /etc/hostname

#Set root password
printf "Set root password...\n"
passwd

# Install bootloader
microcode_type=""
while (microcode_type == "")
do
    printf "Choose microcode updates (intel, amd, none): "
    read microcode_type
    case $microcode_type in
    "intel")
        pacman -S intel-ucode --noconfirm
        ;;
    "amd")
        pacman -S amd-ucode --noconfirm
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
grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot/efi
grub-mkconfig -o /boot/grub/grub.cfg

# Add default user
read -p "Adding default user, enter username: " user_name
useradd -m -G wheel -s /usr/bin/zsh $user_name
printf "Set user password...\n"
passwd $user_name

# Allow sudo for group wheel
sed '/%wheel ALL=(ALL) ALL/s/^#//g' /etc/sudoers

# Download post install script
curl -Lo /home/${user_name}/arch_post_install.sh https://raw.githubusercontent.com/iSkytran/linux-install-scripts/main/arch_post_install.sh
chmod a+x /home/${user_name}/arch_post_install.sh

# End part 2 of install
exit
