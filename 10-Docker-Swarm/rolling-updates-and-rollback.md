# Rolling Updates & Rollback

Swarm can update services with zero downtime using rolling updates, and automatically rollback on failure.

## Updating a Service

```bash
docker service update \
  --image myapp:v2 \
  --update-parallelism 1 \
  --update-delay 10s \
  --update-order start-first \
  myapp
```

### Update Options

- `--update-parallelism`: number of tasks updated simultaneously.
- `--update-delay`: wait between batches (e.g., `10s`).
- `--update-failure-action`: `pause` | `continue` | `rollback` (default: `pause`).
- `--update-order`: `start-first` (new task starts before stopping old) or `stop-first` (old task stops before new starts).

## In Compose

```yaml
deploy:
  replicas: 3
  update_config:
    parallelism: 1
    delay: 10s
    failure_action: rollback
    order: start-first
```

## Monitoring a Rollout

```bash
docker service ps myapp
docker service inspect --pretty myapp
```

Watch for failed tasks.

## Rollback

If an update fails or you need to revert:

```bash
docker service rollback myapp
```

Swarm reverts to the previous service definition.

### Rollback Options

```bash
docker service update --rollback-parallelism 1 --rollback-delay 5s myapp
```

Or in Compose:

```yaml
deploy:
  rollback_config:
    parallelism: 1
    delay: 5s
```

## Health Checks During Updates

Ensure health checks are defined so Swarm knows when a task is ready.

```dockerfile
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD curl -f http://localhost/ || exit 1
```

A task that fails health checks is considered failed, and the update can be halted or rolled back.

## Zero‑Downtime Deployment Pattern

1. Use `start-first` order.
2. Set a generous `update-delay` to let traffic drain.
3. Combine with health checks to ensure new tasks are ready before stopping old.
4. Use a reverse proxy (Traefik/Nginx) that supports graceful draining.

## Testing Updates in Staging

Always test update parameters in a staging swarm before production.

> 🔗 Next: [Scaling & Load Balancing](scaling-and-load-balancing.md)
