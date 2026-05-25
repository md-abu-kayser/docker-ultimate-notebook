# Post‑Installation Configuration (All Platforms)

After installing Docker, perform these steps to ensure a secure, efficient, and user‑friendly setup.

## 1. Run Docker without `sudo` (Linux only)

```bash
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
```

Test: `docker run hello-world` without `sudo`.

## 2. Configure Docker to Start on Boot

- **Linux (systemd)**: `sudo systemctl enable docker.service containerd.service`
- **macOS / Windows**: Docker Desktop starts automatically at login. Toggle in Preferences → General.

## 3. Set Docker Context (if using multiple environments)

Check current context:

```bash
docker context ls
```

Switch context:

```bash
docker context use default
```

## 4. Verify Docker Compose

Docker Desktop ships with Compose V2. Ensure you can use `docker compose` (not the deprecated `docker-compose`):

```bash
docker compose version
```

## 5. Test a Real‑World Image

Run Nginx to confirm networking and port forwarding work:

```bash
docker run -d -p 8080:80 --name test-nginx nginx:alpine
```

Visit `http://localhost:8080`. Stop and remove:

```bash
docker stop test-nginx && docker rm test-nginx
```

## 6. Configure Logging Driver (Optional)

Prevent disk space exhaustion by limiting logs. Create or edit `/etc/docker/daemon.json` (Linux):

```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
```

Restart Docker: `sudo systemctl restart docker`. On macOS/Windows, adjust these settings via Docker Desktop’s **Preferences** → **Docker Engine**.

## 7. Set Resource Limits (Docker Desktop)

- CPU, Memory, Swap, Disk image size can be tweaked in **Preferences** → **Resources**.
- Increase them if you run heavy multi‑container apps.

## 8. Enable BuildKit

For faster builds and advanced features, set BuildKit as the default builder:

```bash
export DOCKER_BUILDKIT=1  # shell
# To make permanent, add to your .bashrc or .zshrc
```

## 9. Pull Useful Base Images

Pre‑fetch commonly used images to save time later:

```bash
docker pull alpine
docker pull ubuntu:22.04
docker pull node:18-alpine
```

## 10. Join the Docker Community

- [Docker Hub](https://hub.docker.com/) – create an account.
- [Docker Forums](https://forums.docker.com/)
- [Docker Slack & Discord](https://www.docker.com/community/)

> 📘 Ready to dive in? Head over to **02‑Docker‑Basics** starting with [Docker Architecture](02-Docker-Basics/architecture.md)
