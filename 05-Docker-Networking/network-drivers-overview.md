# Docker Network Drivers – Overview

Docker’s networking subsystem is pluggable. The built‑in drivers cover most use cases.

## Network Driver Types

| Driver      | Description                                                                                                                   |
| ----------- | ----------------------------------------------------------------------------------------------------------------------------- |
| **bridge**  | Default network driver. Containers on the same bridge can communicate; isolated from host network unless ports are published. |
| **host**    | Removes network isolation; container uses host’s network stack directly. No port mapping needed.                              |
| **overlay** | Connects containers across multiple Docker daemons (Swarm). Uses VXLAN.                                                       |
| **macvlan** | Assigns a MAC address to each container, making it appear as a physical device on the network.                                |
| **ipvlan**  | Similar to macvlan but shares the parent interface’s MAC, avoiding MAC limits.                                                |
| **none**    | Disables networking entirely.                                                                                                 |

## Which One to Choose?

- **bridge**: local development, single‑host apps.
- **host**: when you need maximum network performance and no isolation (e.g., network monitoring tools).
- **overlay**: multi‑host Swarm clusters.
- **macvlan/ipvlan**: legacy applications that need to be on the physical network, network appliances, or when you need to assign static IPs from your corporate network.
- **none**: security‑sensitive containers with no network access.

## Listing Networks

```bash
docker network ls
docker network inspect <name>
```

## Default Networks

When Docker is installed, it creates three networks:

- `bridge` (default bridge)
- `host`
- `none`

Custom networks are always better than the default `bridge` because they provide automatic DNS resolution.

> 🔗 Next: [Bridge Networks Deep Dive](bridge-networks.md)
