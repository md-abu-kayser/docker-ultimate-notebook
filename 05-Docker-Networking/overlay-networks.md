# Overlay Networks

Overlay networks span multiple Docker hosts, enabling communication between containers in a Swarm cluster.

## How Overlay Works

- Creates a VXLAN (Virtual Extensible LAN) tunnel between hosts.
- An overlay network driver manages the overlay subnet.
- Each node has a bridge (e.g., `docker_gwbridge`) for external connectivity and an overlay bridge for internal traffic.

## Prerequisites

- Docker Swarm mode enabled (`docker swarm init` or join).
- Open ports: TCP 2377 (cluster management), UDP 4789 (VXLAN), TCP/UDP 7946 (gossip).

## Creating an Overlay Network

```bash
docker network create --driver overlay --subnet=10.10.0.0/24 my-overlay
```

## Attaching Services

In a Swarm service:

```yaml
services:
  myapp:
    image: myapp
    networks:
      - my-overlay
    deploy:
      replicas: 3
```

Containers can communicate across nodes using service names.

## Encrypted Overlay Network

Add `--opt encrypted` for IPsec encryption of VXLAN traffic:

```bash
docker network create --driver overlay --opt encrypted my-encrypted-overlay
```

This comes with a performance penalty.

## Routing Mesh

Overlay networks automatically enable the Swarm routing mesh, which load‑balances requests to a service’s published port across all nodes, even if the container isn’t on that node.

## Troubleshooting Overlay

- Use `docker network inspect my-overlay` to see peers and subnet.
- Check `docker node ls` to ensure all nodes are active.
- Verify firewall rules allow the required ports.

> 🔗 Next: [Host, Macvlan, IPvlan](host-macvlan-ipvlan.md)
