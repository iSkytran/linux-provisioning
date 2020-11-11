# WSL Install

WSL images can be installed from the Microsoft Store or from a rootfs tarball. Ubuntu tarballs can be found at <https://cloud-images.ubuntu.com/releases/>. Once downloaded, the following can be run in Powershell.

```powershell
wsl --import <Distribution Name> <Install Folder> <.TAR.GZ File Path>
wsl -d <Distribution Name>
```

Then the following commands can be run in WSL to change the default user where `username` is the desired username.

```sh
NEW_USER=username
adduser "${NEW_USER}"
adduser ${NEW_USER} sudo
```

The following needs to be run as one command.

```sh
tee /etc/wsl.conf <<_EOF
[user]
default=${NEW_USER}
_EOF
```

Run `logout` to exit WSL and then the run the following to reboot the distro.

```powershell
wsl -t <Distribution Name>
wsl -d <Distribution Name>
```
