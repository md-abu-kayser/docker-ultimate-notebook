# Docker Restart Policies

Restart policies define what Docker should do when a container exits. They are critical for ensuring service availability.

## Available Policies

| Policy                     | Behavior                                                                         |
| -------------------------- | -------------------------------------------------------------------------------- |
| `no`                       | Do not restart. (Default)                                                        |
| `on-failure[:max-retries]` | Restart only if the exit code is non‑zero. Optionally limit retries.             |
| `always`                   | Always restart regardless of exit code. Stopped manually only via `docker stop`. |
| `unless-stopped`           | Always restart unless explicitly stopped (survives daemon restart).              |

## Choosing a Policy

- **`always`/`unless-stopped`**: for long‑running services (web servers, databases).
- **`on-failure`**: for batch jobs or tasks that should retry on error but not run indefinitely.
- **`no`**: for one‑off containers or development.

## Using with `docker run`

```bash
docker run -d --restart=unless-stopped nginx
```

## Using in Docker Compose

```yaml
services:
  app:
    image: myapp
    restart: unless-stopped
```

## Restart Loop Protection

If a container repeatedly fails and restarts, Docker adds an exponential backoff (up to a minute) to prevent resource exhaustion.

## Swarm Mode Restart Policies

In Swarm, restart policy is part of the service’s `deploy` section:

```yaml
deploy:
  restart_policy:
    condition: on-failure
    delay: 5s
    max_attempts: 3
    window: 120s
```

`condition` can be `none`, `on-failure`, or `any` (always).

## Differences Between `always` and `unless-stopped`

- `always`: Even if you manually stop the container and restart the daemon, it restarts. (Containers with `always` restart on daemon start unless they were stopped before daemon stop.)
- `unless-stopped`: If you manually stop the container, it won’t restart until you start it again. Daemon restart doesn’t affect it.

## Inspecting Current Policy

```bash
docker inspect --format '{{.HostConfig.RestartPolicy}}' <container>
```

## Best Practices

- Always set a restart policy for production services.
- Use `unless-stopped` for most server workloads.
- Combine with health checks to avoid restart loops.

> 📘 Next: [Zero‑Downtime Deployment](zero-downtime-deployment.md)
