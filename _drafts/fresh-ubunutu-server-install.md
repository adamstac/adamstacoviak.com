---
layout: post
title: Fresh Ubunutu Server install
slug: ubuntu-server
date: 2024-04-16 09:00:00+00:00
type: post
description:
---

When I install a fresh copy of Ubunutu Server, I follow a common set of steps to get the new machine setup and ready for action. This post is the exact documentation I use for setting up my systems. I hope this helps you as much as it helps me.

This documention covers most everything I need to do to make my Ubuntu systems homelab/production ready.

I will continue to update this post over time when these steps change. If you have any questions, get in touch with me via [Changelog's community Slack](https://changelog.com/community) in our `#homelab` channel.

## Update and upgrade

Update and upgrade Ubuntu.

```bash
sudo apt update && sudo apt upgrade -y
```

## Install packages

### Proxmox qemu-guest-agent

If you're installing on Proxmox, make sure Proxmox can see the ip address of VM.

```bash
sudo apt install qemu-guest-agent -y
```

### All common packages

```bash
sudo apt install qemu-guest-agent -y && \
sudo apt install neofetch -y && \
sudo apt install htop -y && \
sudo apt install vim -y && \
sudo apt install curl -y && \
sudo apt install git -y && \
sudo apt install zsh -y && \
sudo apt install dnsutils -y && \
sudo apt install iputils-ping -y
```

### Select common packages

Common packages to install.

- `neofetch`
- `htop`
- `vim`
- `curl`
- `git`
- `zsh`

Install each individually.

```bash
sudo apt install neofetch -y
```

```bash
sudo apt install htop -y
```

```bash
sudo apt install curl -y
```

```bash
sudo apt install git -y
```

```bash
sudo apt install zsh -y
```

### Network diagnostic packages

```bash
sudo apt install dnsutils -y && \
sudo apt install iputils-ping -y
```

See also: https://chat.openai.com/share/ec5de08f-72c8-4dd4-94a2-9ff6dc5f803a

## Set timezone

```bash
timedatectl status
```

```bash
sudo timedatectl set-timezone America/Chicago
```

## Oh my ZSH

Install Oh my ZSH.

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Update theme selection

To modify the `ZSH_THEME` value using `sed`:

```bash
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="candy"/' ~/.zshrc
```

Here's a breakdown of the `sed` command:

- `-i`: This option tells `sed` to edit the file in place.
- `'s/ZSH_THEME="robbyrussel"/ZSH_THEME="candy"/'`: This is the substitution command for `sed`. It will replace the string `ZSH_THEME="robbyrussel"` with `ZSH_THEME="candy"`.

After running this command, `~/.zshrc` will be updated with the new theme value.

### Vim love

Also add some `vim` love:

```bash
echo -e '\nexport VISUAL=vim\nexport EDITOR="$VISUAL"' >> ~/.zshrc
```

### Auto update

#### Modern way

```bash
sed -i 's/# zstyle \':omz:update\' mode auto/zstyle \':omz:update\' mode auto/' ~/.zshrc
```

Remember to source the ﻿~/.zshrc file or restart your terminal to apply changes:

```bash
source ~/.zshrc
```

#### Legacy way

```bash
sed -i 's/source \$ZSH\/oh-my-zsh.sh/DISABLE_UPDATE_PROMPT=true\nsource \$ZSH\/oh-my-zsh.sh/' ~/.zshrc
```

```bash
sed -i 's/source \$ZSH\/oh-my-zsh.sh/DISABLE_AUTO_UPDATE=true\nsource \$ZSH\/oh-my-zsh.sh/' ~/.zshrc
```

---

## Tailscale

Primary download page - https://tailscale.com/download

Tailscale Packages (stable track) - https://pkgs.tailscale.com/stable/

## Tailscale auth key command

```bash
sudo tailscale up --authkey [SEE 1PASSWORD]
```

```bash
sudo tailscale up --accept-dns=false --authkey tskey-auth-asdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfa
```

### Ubuntu 22.04 LTS (Jammy Jellyfish)

```bash
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
```

Add the tailscale repository

```bash
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list
```

Install Tailscale

```bash
sudo apt update && sudo apt install tailscale -y
```

Start Tailscale!

```bash
sudo tailscale up
```

If you're using Tailscale on a Pi-Hole machine or a machine you want to ensure DNS remains local to the network, use this command to launch Tailscale.

```bash
sudo tailscale up --accept-dns=false
```

### Ubuntu 23.04 (Lunar Lobster)

#### Add Tailscale's GPG key

```bash
sudo mkdir -p --mode=0755 /usr/share/keyrings
```

```bash
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/lunar.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
```

#### Add the tailscale repository

```bash
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/lunar.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list
```

#### Install Tailscale

```bash
sudo apt-get update && sudo apt-get install tailscale
```

#### Start Tailscale!

```bash
sudo tailscale up
```

### Ubuntu 22.10 (Kinetic Kudu)

Add Tailscale's GPG key

```bash
sudo mkdir -p --mode=0755 /usr/share/keyrings
```

```bash
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/kinetic.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
```

Add the tailscale repository

```bash
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/kinetic.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list
```

Install Tailscale

```bash
sudo apt update && sudo apt install tailscale
```

Start Tailscale!

```bash
sudo tailscale up
```

### Raspian

```
sudo apt-get install apt-transport-https

curl -fsSL https://pkgs.tailscale.com/stable/raspbian/bullseye.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg > /dev/null

curl -fsSL https://pkgs.tailscale.com/stable/raspbian/bullseye.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list

sudo tailscale up
```

---

## Static IP address

See [[Ubuntu Server - Static IP]] for details.

---

## Docker and Docker Compose

Install Docker - https://docs.docker.com/engine/install/ubuntu/

### Setup repo

```bash
sudo apt update
```

```bash
sudo apt install ca-certificates curl
```

Add Docker’s official GPG key:

```bash
sudo install -m 0755 -d /etc/apt/keyrings
```

```bash
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
```

```console
sudo chmod a+r /etc/apt/keyrings/docker.asc
```

Use the following command to add the repository to Apt sources:

```bash
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

Update the `apt` package index:

```bash
sudo apt update
```

Install the latest version of Docker:

```bash
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
```

If you want to run docker as non-root user then you need to add it to the docker group.

Create the docker group if it doesn't exist.

```bash
sudo groupadd docker
```

Add your user to the docker group.

```bash
sudo usermod -aG docker $USER
```

Log out and log back in and docker should run without root.

Verify that the Docker Engine installation is successful by running the hello-world image.

```bash
sudo docker run hello-world
```

---

## Todo

1. Document setting up ufw
2. Learn how to auto install secutiry updates
3. Set up fail2ban

---

## Security Hardening

https://www.informaticar.net/security-hardening-ubuntu-20-04/

### Lock ssh login for root

```
sudo vim /etc/ssh/sshd_config
```

Set `PermitRootLogin` to "no".

```
PermitRootLogin no
```

By setting `PermitRootLogin no`, the root user will not be able to log in via SSH, even if the password is unlocked in the future. This is generally recommended for security reasons, as it reduces the likelihood of unauthorized access to the root account.

### Enable SSH Protocol 2

SSH Protocol 2 is considered more secure and robust than SSH Protocol 1, and is the preferred choice for most modern SSH implementations.

There are two versions of the SSH protocol: SSH Protocol 1 and SSH Protocol 2.

**SSH Protocol 1** was the original version of the protocol and was introduced in the mid-1990s. It uses a simple, 8-bit ASCII encoding format and provides basic encryption and authentication features. SSH Protocol 1 relies on the RSA algorithm for encryption and authentication, which has been found to have vulnerabilities.

**SSH Protocol 2** was introduced in the early 2000s as a more secure and robust version of the protocol. It uses a more advanced, binary encoding format and provides stronger encryption and authentication features. SSH Protocol 2 supports a range of encryption and authentication algorithms, including the more secure Elliptic Curve Cryptography (ECC) and Diffie-Hellman (DH) key exchange.

```
sudo vim /etc/ssh/sshd_config
```

Here's a sample of `/etc/ssh/sshd_config` with `Protocol 2` added near the top of the file.

```
# This is the sshd server system-wide configuration file.  See
# sshd_config(5) for more information.

# This sshd was compiled with PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games

# The strategy used for options in the default sshd_config shipped with
# OpenSSH is to specify options with their default value where
# possible, but leave them commented.  Uncommented options override the
# default value.

Protocol 2

Include /etc/ssh/sshd_config.d/*.conf
```

Once you've updated the file you need to restart the ssh service.

```
sudo systemctl restart ssh
```

## Unattended upgrades

```bash
sudo apt update && sudo apt install unattended-upgrades -y
```

```bash
sudo dpkg-reconfigure unattended-upgrades
```

---

## Remove garbage

See also https://linuxhint.com/turn-off-snap-ubuntu/

Disable cloud-init.

```
touch /etc/cloud/cloud-init.disabled
```

Remove snapd

```
apt autoremove --purge -y snapd
```

---

## Resources

https://christitus.com/switching-to-ubuntu/
https://linuxhint.com/40_things_after_installing_ubuntu/
