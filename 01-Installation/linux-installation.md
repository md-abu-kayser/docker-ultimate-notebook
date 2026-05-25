# Installing Docker on Linux

This guide covers installation on **Ubuntu / Debian**, **CentOS / RHEL / Fedora**, and generic Linux distributions using the convenience script. Docker runs natively on Linux, making it the ideal host.

## Prerequisites

- A 64‑bit Linux kernel version 3.10 or higher.
- `sudo` privileges.
- Remove any older versions of Docker (docker, docker-engine, docker.io).

## 1. Uninstall Old Versions

```bash
sudo apt-get remove docker docker-engine docker.io containerd runc
```

For RHEL/CentOS:

```bash
sudo yum remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine
```

## 2. Install Docker Engine – Ubuntu / Debian

### Update package index & install dependencies

```bash
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg lsb-release
```

### Add Docker’s official GPG key

```bash
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```

### Set up the stable repository

```bash
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

### Install Docker Engine

```bash
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
```

## 3. Install Docker Engine – CentOS / RHEL / Fedora

### Install required packages

```bash
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
```

### Install Docker

```bash
sudo yum install docker-ce docker-ce-cli containerd.io docker-compose-plugin
```

### Start and enable Docker

```bash
sudo systemctl start docker
sudo systemctl enable docker
```

## 4. Verify the Installation

Run the hello-world image to confirm everything works:

```bash
sudo docker run hello-world
```

Expected output: a welcome message confirming your installation.

## 5. Manage Docker as a Non‑root User

Create the `docker` group and add your user:

```bash
sudo groupadd docker
sudo usermod -aG docker $USER
```

Log out and back in (or run `newgrp docker`) for the changes to take effect. Now you can run `docker` without `sudo`.

## 6. Using the Convenience Script (Quick install)

For development environments, Docker provides an automated script:

```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```

⚠️ Only use this in trusted environments; review the script first.

## 7. Enable Docker to Start on Boot

Most distributions use `systemd`:

```bash
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
```

## 8. Update Docker

Simply run your package manager’s update command:

```bash
sudo apt-get update && sudo apt-get upgrade docker-ce docker-ce-cli containerd.io
```

> 🔗 Next: [Post‑installation Steps for All Platforms](post-install-steps.md)
