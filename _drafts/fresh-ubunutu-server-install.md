---
layout: post
title: Fresh Ubunutu Server install
slug: ubuntu-new
type: post
description: 
---

When I install a fresh new copy of Ubunutu Server, there is a common set of steps and packages that I run through to get the new machine setup. These are those instructions.

After setting up my Ubuntu servers, there are a few things I do before I use them for their intended purpose. This ranges from ..., and more. Join me as we pick up where the rest of the tutorials stop, and that's everything you need to do to make these homelab/production ready.

I will continue to update this post over time when these steps change. If you have any questions, get in touch with me via [Twitter](https://twitter.com/adamstac) DMs.

## Update and upgrade Ubuntu

First thing's first. Before I do ANYTHING at all with this new server install, I update and upgrade Ubuntu to ensure I have the latest packages and security updates.

```bash
sudo apt update && sudo apt upgrade -y
```

If you're installing on Proxmox, install the `qemu-guest-agent` to ensure Proxmox can see the IP address of VM.

```bash
sudo apt install qemu-guest-agent
```

## Add my SSH key

I'm on a Mac.

```bash
ssh-copy-id -f 192.168.1.x
```

### SSH directory permissions

Your `.ssh` directory permissions should be `700` or `drwx------` in octal format.

```bash
sudo chmod 700 ~/.ssh
```

Your public key file (`.pub` file) should be `644` or `(-rw-r--r--)` in octal format.

```bash
sudo chmod 644 ~/.ssh/id_ed25519.pub
```

Your private key file (`id_ed25519`) and `authorized_keys` file should be `600` or `-rw-------` in octal format.

```bash
sudo chmod 600 ~/.ssh/id_ed25519
```

```bash
sudo chmod 600 ~/.ssh/authorized_keys
```

Read this if you need a refresher on [[File permissions in Linux]].

## Common packages

The following packages are "must install" packages for me.

- `neofetch`
- `htop`
- `vim`
- `curl`
- `git`
- `zsh`

This command combines each of these into a one liner.

```bash
sudo apt install neofetch -y && \
sudo apt install htop -y && \
sudo apt install vim -y && \
sudo apt install curl -y && \
sudo apt install git -y && \
sudo apt install zsh -y
```

Or, you can do each individually.

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

## Oh my ZSH

Install Oh my ZSH.

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

## Install Tailscale

For the most part I'm installing and setting up Ubuntu 22.04 LTS (Jammy Jellyfish). Other flavors I tend to use are Ubuntu 22.10 (Kinetic Kudu) or Raspberry Pi OS (formerlly known as Raspbian). I have all three options outlined in my personal docs, but I'm onlu included the most common here for Ubuntu 22.04 LTS (Jammy Jellyfish).

Please consult [Tailscale's primary download page](https://tailscale.com/download) for more details.

I also found [this page](https://pkgs.tailscale.com/stable/) which has install instructions for every operating systems that Tailscale Packages are available for.

### Ubuntu 22.04 LTS (Jammy Jellyfish)

Installation instructions for Ubuntu 22.04 LTS (Jammy Jellyfish).

Add Tailscale's GPG key.

```bash
sudo mkdir -p --mode=0755 /usr/share/keyrings
```

```bash
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
```

Add the tailscale repository.

```bash
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list
```

Install Tailscale.

```bash
sudo apt update && sudo apt install tailscale -y
```

Start Tailscale!

```bash
sudo tailscale up
```

## Static IP address

See [[Ubuntu Server - Static IP]] for details.

## Docker and Docker Compose

Install Docker - https://docs.docker.com/engine/install/ubuntu/

### Setup repo

```bash
sudo apt-get update
```

```bash
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
```

Add Docker’s official GPG key:

```bash
sudo mkdir -p /etc/apt/keyrings
```

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```

Use the following command to set up the repository:

```bash
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

Update the `apt` package index:

```bash
sudo apt-get update
```

Install the latest version of Docker:

```bash
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
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