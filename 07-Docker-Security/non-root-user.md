# Running Containers as a Non‑Root User

By default, containers run as `root` (UID 0) inside their namespace. Running as root in the container can lead to privilege escalation if the container is compromised.

## Why Non‑Root?

- Limits the damage from a container breakout.
- Aligns with the principle of least privilege.
- Many orchestration platforms (Kubernetes) enforce security contexts.

## Creating a Non‑Root User in Dockerfile

```dockerfile
FROM node:18-alpine

# Create a group and user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Create app directory and set ownership
WORKDIR /app
COPY --chown=appuser:appgroup . .

# Switch to non‑root user
USER appuser

CMD ["node", "server.js"]
```

- `addgroup -S` and `adduser -S` create system users (no login).
- `--chown` changes file ownership during COPY.

## For Debian/Ubuntu Base Images

```dockerfile
RUN groupadd -r mygroup && useradd -r -g mygroup myuser
USER myuser
```

## Runtime: Override User

You can override the user at container start:

```bash
docker run -u 1000:1000 myimage
```

- Use `-u` with a numeric UID:GID or username.
- The user must exist inside the image.

## Adjusting File Permissions

Ensure the non‑root user can read/write required directories:

```dockerfile
RUN mkdir -p /app/data && chown appuser:appgroup /app/data
```

## Port Binding with Non‑Root

Ports below 1024 require `NET_BIND_SERVICE` capability. You can:

- Grant the capability:
  ```bash
  docker run --cap-add=NET_BIND_SERVICE -u appuser nginx
  ```
- Or use a higher port (e.g., 8080) and map it externally.

## Verifying User Inside Container

```bash
docker exec <container> id
# uid=1001(appuser) gid=1001(appgroup) groups=1001(appgroup)
```

## Pitfalls

- Some images (like official nginx) start as root and drop privileges after binding ports. That’s acceptable if the main process then runs as non‑root.
- If you must run as root, apply other hardening measures (seccomp, read‑only filesystem).

> 📘 Next: [Capabilities, Seccomp & AppArmor](capabilities-seccomp-apparmor.md)
