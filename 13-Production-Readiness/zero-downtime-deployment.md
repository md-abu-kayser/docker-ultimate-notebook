# Zero‑Downtime Deployment

Achieving zero‑downtime deployments means updating a running application without clients experiencing errors or downtime.

## Techniques for Docker

### 1. Swarm Rolling Updates

Swarm’s native rolling updates replace tasks one by one.

```bash
docker service update --image myapp:v2 --update-parallelism 1 --update-delay 10s myservice
```

With a health check defined, Swarm waits for the new task to become healthy before proceeding.

### 2. Blue‑Green Deployment with Docker Compose

Maintain two identical environments (blue and green) and switch traffic via a reverse proxy.

Steps:

- Deploy new version (green) alongside old (blue) on a different port.
- Validate green.
- Update Nginx/HAProxy to point to green.
- Tear down blue.

Simplified example using two Compose files and a shared network:

```bash
# Start green
docker compose -f docker-compose.green.yml up -d
# Test green on port 8081
# Switch reverse proxy to green
docker compose exec proxy nginx -s reload
# Stop blue
docker compose -f docker-compose.blue.yml down
```

### 3. Using Traefik with Docker Labels

Traefik can automatically detect new versions and gracefully drain connections.

### 4. Graceful Shutdown

Your application must handle `SIGTERM` and finish in‑flight requests before exiting.
Docker sends `SIGTERM`, waits for `stop_grace_period` (default 10s), then `SIGKILL`.

```yaml
services:
  app:
    image: myapp
    stop_grace_period: 30s
```

### 5. Connection Draining

Use a load balancer that can drain connections from a container before stopping it.

## Health Checks Are Mandatory

Without health checks, Docker assumes a container is ready immediately, which may cause failed requests. Define a proper `HEALTHCHECK`.

## Database Migrations

Zero‑downtime requires backward‑compatible database changes. Run migrations that can work with both old and new application versions.

## Rollback Plan

Always be able to rollback quickly. With Swarm:

```bash
docker service rollback myservice
```

With blue‑green, simply switch back to the old environment.

## Testing the Deployment

Validate the new version with a health endpoint before exposing to users.

> 📘 Next: [Backup & Restore](backup-and-restore.md)
