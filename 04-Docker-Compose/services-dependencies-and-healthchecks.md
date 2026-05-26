# Services, Dependencies, and Healthchecks

## Service Dependencies

Use `depends_on` to control the startup order:

```yaml
services:
  web:
    image: nginx
    depends_on:
      - api
  api:
    image: my-api
    depends_on:
      - db
  db:
    image: postgres
```

- `depends_on` only waits for the container to **start**, not for the service to be ready.
- For readiness, combine with healthchecks (see below) or a tool like `wait-for-it`.

## Controlling Startup with Conditions (Compose v3.9+)

```yaml
depends_on:
  db:
    condition: service_healthy
```

Possible conditions: `service_started`, `service_healthy`, `service_completed_successfully`.

## Healthcheck in Dockerfile

```dockerfile
HEALTHCHECK --interval=10s --timeout=3s --retries=5 \
  CMD pg_isready -U postgres || exit 1
```

Then in Compose, the `condition: service_healthy` works.

## Healthcheck in Compose File (override or add)

```yaml
services:
  api:
    image: my-api
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
```

## Using a Wait Script

Add a simple wait wrapper:

```dockerfile
COPY wait-for-it.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/wait-for-it.sh
CMD ["wait-for-it.sh", "db:5432", "--", "node", "server.js"]
```

## Long‑Running Services and Restart Policies

```yaml
services:
  worker:
    image: my-worker
    restart: always
```

Other options: `no`, `on-failure`, `unless-stopped`.

## Scaling Services

```bash
docker compose up -d --scale worker=3
```

Note: port collision must be avoided when scaling; use dynamic port assignment or a load balancer.

> 🔗 Next: [Volumes and Networks in Compose](volumes-and-networks.md)
