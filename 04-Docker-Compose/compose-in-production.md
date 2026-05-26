# Docker Compose in Production

While Docker Compose was originally designed for development, it can be used in production for simple deployments or as a stepping stone to orchestrators.

## Is Compose Suitable for Production?

**Yes, with caveats:**

- Single‑host only (no multi‑node clustering).
- No built‑in rolling updates or auto‑scaling.
- Limited secret management (without Swarm).
- But for small projects, internal tools, or staging environments, it’s perfectly adequate.

## Using Compose with Docker Swarm

`docker stack deploy` uses the same Compose file syntax but leverages Swarm for orchestration:

```bash
docker stack deploy -c docker-compose.yml myapp
```

- Adds features like rolling updates, service replication, secrets, configs.

## Production Compose Tips

- Always pin image tags (digests or exact versions).
- Use `restart: always` or `unless-stopped`.
- Bind logs to the host or a logging driver.
- Store persistent data outside the container (volumes/bind mounts with backups).
- Set resource limits:
  ```yaml
  deploy:
    resources:
      limits:
        cpus: "0.5"
        memory: 256M
  ```
  (Only works with `docker stack deploy` or Compose V3 with `--compatibility` flag)

## Zero‑Downtime Deployment with Compose

Not native, but you can achieve it with a blue‑green approach using a reverse proxy (Traefik, Nginx) and scaling:

```bash
docker compose up -d --scale app=2
docker compose exec reverse-proxy nginx -s reload
```

## Monitoring and Logging

Use `docker compose logs` for quick checks. For production, integrate with:

- **ELK stack** or **Loki** for centralized logging.
- **Prometheus + Grafana** for metrics.

## Backup and Restore

- Named volumes: use `docker run --rm -v volume:/data -v $(pwd):/backup alpine tar czf /backup/backup.tar.gz -C /data .`
- Databases: use native dump tools (pg_dump, mongodump) and store in cloud storage.

## When to Move to Kubernetes/Swarm

- Need multi‑host, auto‑scaling, zero‑downtime deployments, advanced networking, or service discovery.
- Compose can still be used for local development and CI while the same images are deployed to K8s.

> 🎉 Congratulations! You’ve completed the **Docker Compose** section.

> 📘 Ready to dive in? Head over to **05-Docker-Networking** starting with [Network Drivers Overview](../05-Docker-Networking/network-drivers-overview.md)
