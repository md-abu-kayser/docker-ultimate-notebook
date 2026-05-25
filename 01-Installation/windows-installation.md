# Installing Docker on Windows

Docker on Windows comes in two main flavours:

- **Docker Desktop for Windows** (WSL 2 backend – recommended)
- **Docker Toolbox** (legacy, no longer maintained)

## Prerequisites

- Windows 10 64‑bit: Pro, Enterprise, or Education (version 1903 or higher) with WSL 2 enabled.
- Windows 11: all editions.
- Virtualisation enabled in the BIOS.
- For WSL 2 backend: Windows Subsystem for Linux 2 installed.

## Enable WSL 2 (If not already enabled)

Open PowerShell as Administrator and run:

```powershell
wsl --install
```

Restart your machine. Then set WSL 2 as default:

```powershell
wsl --set-default-version 2
```

Install a Linux distribution from the Microsoft Store (e.g., Ubuntu) or let Docker do it automatically.

## Install Docker Desktop

### 1. Download the Installer

Visit [https://docs.docker.com/desktop/install/windows-install/](https://docs.docker.com/desktop/install/windows-install/) and download **Docker Desktop for Windows**.

### 2. Run the Installer

- Double‑click the `Docker Desktop Installer.exe`.
- Follow the setup wizard. Ensure **“Use WSL 2 instead of Hyper‑V”** is selected (if you have WSL 2).
- Allow the installer to add the required Windows features and restart if prompted.

### 3. Start Docker Desktop

After installation, Docker Desktop starts automatically (whale icon in the system tray). Accept the licence terms.

### 4. Verify Installation

Open a terminal (PowerShell or WSL) and run:

```bash
docker --version
docker run hello-world
```

If Docker Desktop uses the WSL 2 backend, you can run Docker commands from any WSL distribution.

## Alternative: Docker Engine on WSL without Docker Desktop

Advanced users can install Docker Engine directly inside a WSL 2 distribution (like Ubuntu) using the Linux installation method. This avoids the Docker Desktop resource overhead.

### Quick Steps

```bash
# Inside your WSL Ubuntu
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo service docker start
```

Add your user to the `docker` group.

> 🔗 Next: [Post‑installation Steps for All Platforms](post-install-steps.md)
