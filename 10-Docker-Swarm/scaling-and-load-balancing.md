# Scaling & Load Balancing in Swarm

Swarm provides built‑in scaling and load balancing for services.

## Scaling Services

```bash
docker service scale myweb=5
```

Or update replicas:

```bash
docker service update --replicas 5 myweb
```

## Auto‑Scaling?

Swarm does not have native auto‑scaling. You can implement custom auto‑scaling with:

- External monitoring (Prometheus + Alertmanager).
- Scripts that call `docker service scale` based on metrics.
- Container‑orchestration platforms that wrap Swarm.

## Load Balancing

Swarm offers two levels of load balancing:

### 1. Internal Load Balancing (VIP)

- Each service gets a virtual IP (VIP) that round‑robins DNS among task IPs.
- Traffic between services is load‑balanced automatically.
- Use service name to reach the VIP.

### 2. External Load Balancing (Routing Mesh)

- When a port is published (`--publish 80:80`), every node in the swarm listens on that port.
- The ingress network routes traffic to any available task, regardless of which node the task is on.
- This is the **routing mesh**.

#### Example

```bash
docker service create --name web --replicas 3 --publish 80:80 nginx
```

Any node’s IP on port 80 will serve the Nginx page.

## Bypassing the Routing Mesh (Host Mode)

```bash
docker service create --name web --publish mode=host,published=80,target=80 nginx
```

Traffic only goes to tasks running on that node. Useful for performance or session affinity.

## Sticky Sessions (Session Affinity)

Swarm does not natively support sticky sessions. Use an external load balancer (Traefik, HAProxy, Nginx) with cookie‑based affinity.

## Using a Reverse Proxy

Deploy Traefik or Nginx as a Swarm service to handle SSL termination, path routing, and sticky sessions.

### Traefik Example

```yaml
services:
  reverse-proxy:
    image: traefik:v2.10
    command:
      - "--providers.docker.swarmMode=true"
      - "--entrypoints.web.address=:80"
    ports:
      - "80:80"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    deploy:
      mode: global
```

## Performance Tips

- Use `mode=host` for high‑throughput services that don’t need mesh routing.
- Use `--dns-option` for custom DNS round‑robin behavior.
- Monitor connection distribution.

> 🔗 Next: [Maintenance & Troubleshooting](maintenance-and-troubleshooting.md)
