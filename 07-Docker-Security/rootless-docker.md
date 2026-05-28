# Rootless Docker

Rootless mode runs the Docker daemon and containers within a user namespace, removing the dependency on root privileges.

## Why Rootless?

- No root access means a container breakout doesn’t give the attacker root on the host.
- Improved security posture for shared machines.
- Useful in environments where you can’t or shouldn’t run as root.

## How It Works

- Docker daemon runs as a non‑root user.
- Containers are launched with user namespaces, mapping the container’s root to the host’s unprivileged user.
- Networking uses slirp4netns (userspace networking) by default, which has some performance and feature limitations.

## Installing Rootless Docker

On Linux (with systemd):

```bash
# Prerequisites: uidmap package
sudo apt-get install -y uidmap

# Run the rootless installation script
dockerd-rootless-setuptool.sh install
```

Add the following to `~/.bashrc`:

```bash
export PATH=/usr/bin:$PATH
export DOCKER_HOST=unix:///run/user/1000/docker.sock
```

## Starting Rootless Docker

```bash
systemctl --user start docker
systemctl --user enable docker
docker run hello-world
```

## Limitations

- Cannot bind to privileged ports (<1024) unless using `CAP_NET_BIND_SERVICE` (which requires kernel unprivileged ports support).
- Overlay network doesn’t work; use `bridge` network.
- Performance overhead from slirp4netns (mitigated with `--network=host` if allowed).
- Some storage drivers may not work (overlay2 is supported with specific kernel config).

## Running Containers as Root inside Rootless Docker

Inside the container, you can still be root (UID 0), but that root is mapped to the host’s non‑root user, so host access is limited.

## Enabling cgroups v2

Rootless Docker works best with cgroups v2. Check with:

```bash
mount | grep cgroup2
```

## Troubleshooting

- Ensure `/etc/subuid` and `/etc/subgid` have entries like `username:100000:65536`.
- Check logs: `journalctl --user -u docker.service`.
- For better networking, you can use `--network=host` (if the user has CAP_NET_RAW).

> 🎉 Congratulations! You’ve completed the **Docker Security** section.

> 📘 Ready to dive in? Head over to **08‑Development‑Workflow** starting with [Local Dev with Compose](../08-Development-Workflow/local-dev-with-compose.md)
