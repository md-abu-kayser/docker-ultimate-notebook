# Networking in Docker Swarm

Swarm networking extends Docker’s networking to multiple hosts, providing service discovery, load balancing, and secure communication.

## Network Drivers in Swarm

- **Overlay**: multi‑host networking (default for services).
- **Ingress**: special overlay for published ports (routing mesh).
- **docker_gwbridge**: bridge to connect containers to the host’s external network.

## Overlay Networks

Create an overlay network to allow containers on different nodes to communicate:

```bash
docker network create --driver overlay --subnet 10.10.0.0/24 my-overlay
```

Attach services:

```bash
docker service create --network my-overlay --name backend mybackend
```

## Ingress Network

- Automatically created when the first service publishes a port.
- Implements the **routing mesh**: any node in the swarm can accept requests on published ports and forward them to a task, even if the node isn’t running that task.
- Uses IPVS for layer‑4 load balancing.

### Publishing Ports

```bash
docker service create --name web --publish 80:80 nginx
```

Now every node in the swarm listens on port 80 and forwards to a web task.

## Custom Ingress Network

You can create a custom ingress network if you need a specific subnet:

```bash
docker network create --driver overlay --ingress --subnet 172.20.0.0/16 my-ingress
```

Then publish using that network.

## Internal Load Balancing

- DNS round‑robin inside the swarm: queries to a service name return IPs of all replicas.
- Connection‑level load balancing via IPVS.

## Service Discovery

Swarm’s embedded DNS server resolves service names to virtual IPs (VIP). You can also use task‑level DNS (`tasks.<service>`).

## Configuring Service Networks

```yaml
services:
  api:
    networks:
      - backend
      - frontend
networks:
  backend:
    driver: overlay
  frontend:
    driver: overlay
```

## Troubleshooting

- `docker network inspect <network>` – see attached containers.
- Use `docker exec -it <container> ping <service_name>` to test connectivity.
- Ensure firewall ports are open (7946, 4789).

> 🔗 Next: [Secrets and Configs](secrets-and-configs.md)
