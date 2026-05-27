# Docker Security Best Practices

Securing Docker requires a layered approach – from image creation to runtime configuration and host hardening.

## 1. Use Minimal Base Images

- Prefer **distroless**, **alpine**, or **scratch** over full‑blown OS images.
- Smaller images mean fewer vulnerabilities and a smaller attack surface.

## 2. Run as a Non‑Root User

- Never run containers as `root` unless absolutely necessary.
- Use `USER` instruction in Dockerfile.
- Drop capabilities that the application doesn’t need.

## 3. Keep Images Up‑to‑Date

- Regularly rebuild and redeploy images with the latest security patches.
- Use automated vulnerability scanning (Trivy, Snyk, Docker Scout).

## 4. Avoid Leaking Secrets

- Do not hardcode passwords or API keys in Dockerfiles or environment variables.
- Use Docker Secrets (Swarm), build‑time secrets (BuildKit), or external secret stores.

## 5. Sign and Verify Images

- Enable Docker Content Trust (`DOCKER_CONTENT_TRUST=1`) to enforce image signing.
- Use `docker trust` commands to manage signatures.

## 6. Limit Resource Usage

- Constrain CPU and memory to prevent denial‑of‑service from a single container.
- Use `--cpus`, `--memory`, and `--pids-limit`.

## 7. Restrict Linux Capabilities

- Drop all capabilities and add only what’s needed:
  ```bash
  docker run --cap-drop=ALL --cap-add=NET_BIND_SERVICE nginx
  ```

## 8. Apply Seccomp and AppArmor Profiles

- The default seccomp profile already blocks many syscalls.
- Create custom profiles for your application to restrict further.

## 9. Make Filesystem Read‑Only

- Use `--read-only` to prevent container processes from writing to the image.
- Mount writable directories only where needed (`/tmp`, `/var/run`).

## 10. Network Security

- Avoid using `--net=host` unless required.
- Use user‑defined bridge networks for isolation.
- Disable inter‑container communication (`--icc=false`) if not needed.

## 11. Docker Daemon Hardening

- Run the Docker daemon with `--userns-remap` (user namespace remapping).
- Expose the Docker socket only when necessary; never mount `/var/run/docker.sock` into untrusted containers.
- Enable TLS authentication for remote daemon access.

## 12. Host Security

- Keep the host OS patched.
- Run Docker Engine as a non‑root user where possible (rootless mode).
- Use SELinux or AppArmor on the host.

> 📘 Next: [Running Containers as Non‑Root](non-root-user.md)
