# Installing Docker on macOS

Docker Desktop for Mac provides a seamless experience with a native hypervisor (HyperKit) and a user‑friendly GUI. It includes Docker Engine, Docker CLI, Docker Compose, and Kubernetes.

## System Requirements

- macOS 11 (Big Sur) or newer.
- At least 4 GB of RAM.
- Virtualisation enabled in the BIOS (Intel‑based Macs) or Apple Silicon support (M1/M2 – use the Apple Silicon installer).

## Installation Steps

### 1. Download Docker Desktop

Go to [https://docs.docker.com/desktop/install/mac-install/](https://docs.docker.com/desktop/install/mac-install/) and download the appropriate `.dmg` file:

- **Intel Chip**: standard installer.
- **Apple Silicon**: `Docker.dmg` for ARM64.

### 2. Install the Application

- Double‑click the `.dmg` file.
- Drag the Docker icon into the **Applications** folder.

### 3. Launch Docker Desktop

- Open Docker from the Applications folder.
- Accept the licence agreement.
- Docker will ask for privileged access to install networking components and links. Enter your macOS password when prompted.

### 4. Verify Installation

Open a terminal and run:

```bash
docker --version
docker compose version
docker run hello-world
```

The Docker whale icon will appear in the menu bar when Docker Desktop is running.

### 5. Configure Resources (Optional)

- Click the Docker menu bar icon → **Preferences** → **Resources**.
- Adjust CPUs, memory, swap, and disk image size according to your workload.
- On Apple Silicon, enable **“Use Rosetta for x86/amd64 emulation”** if you need to run Intel‑based images.

## Command‑Line Only Alternative (colima)

For a lightweight, CLI‑only experience, use **Colima**:

```bash
brew install colima docker docker-compose
colima start
```

Colima runs a Linux VM with Docker without a GUI. Verify with `docker run hello-world`.

> 🔗 Next: [Post‑installation Steps for All Platforms](post-install-steps.md)
