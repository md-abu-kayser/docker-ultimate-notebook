# Docker Health Checks

The `HEALTHCHECK` instruction tells Docker how to test if a container is still working. This is vital for production and for Swarm rolling updates.

## Dockerfile HEALTHCHECK

```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD curl -f http://localhost/health || exit 1
```

Options:

- `--interval`: time between checks (default 30s).
- `--timeout`: check command timeout (default 30s).
- `--start-period`: initial grace period before checks count.
- `--retries`: consecutive failures needed to mark unhealthy.

## Health Status Values

- `starting`: during start‑period.
- `healthy`: checks pass.
- `unhealthy`: max retries exceeded.

## Viewing Health Status

```bash
docker ps
docker inspect --format='{{json .State.Health}}' <container> | jq
```

## Example: PostgreSQL Health Check

```dockerfile
FROM postgres:15
HEALTHCHECK --interval=5s --timeout=3s --retries=5 \
  CMD pg_isready -U postgres || exit 1
```

## Example: Custom Script

```dockerfile
COPY healthcheck.sh /usr/local/bin/
HEALTHCHECK CMD /usr/local/bin/healthcheck.sh
```

## Disabling Health Check

If you inherit an image with a health check you don’t want:

```dockerfile
HEALTHCHECK NONE
```

## Health Checks in Compose

You can override or define health checks in Compose:

```yaml
services:
  api:
    image: myapp
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 10s
      timeout: 5s
      retries: 3
      start_period: 30s
```

## Using Health Checks with Swarm

Swarm respects health checks during rolling updates: if a new task becomes unhealthy, the update can be paused or rolled back based on `update_failure_action`.

## Best Practices

- Use lightweight commands (curl, wget, pg_isready).
- Avoid heavy scripts that consume CPU.
- Ensure the health endpoint is fast and reliable.
- Use `start_period` for slow‑starting apps.

> 🎉 Congratulations! You’ve completed the **Monitoring Logging** section.

> 📘 Ready to dive in? Head over to **12‑Advanced‑Docker** starting with [BuildKit & Buildx](../12-Advanced-Docker/buildkit-and-buildx.md)
