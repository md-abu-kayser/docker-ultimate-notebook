# Setting Up a Docker Swarm Cluster

A step‑by‑step guide to creating a production‑ready Swarm cluster.

## Prerequisites

- 3+ Linux hosts with Docker Engine installed (same version).
- Static IPs or proper DNS resolution.
- Open firewall ports:
  - TCP 2377 (cluster management)
  - TCP/UDP 7946 (gossip)
  - UDP 4789 (overlay network)

## Step 1: Initialize the First Manager

On the first manager node:

```bash
docker swarm init --advertise-addr <MANAGER-IP>
```

Record the join tokens output.

## Step 2: Add Worker Nodes

On each worker node, run the join command:

```bash
docker swarm join --token SWMTKN-1-... <MANAGER-IP>:2377
```

## Step 3: Add Additional Managers (for HA)

On the first manager, generate a manager join token:

```bash
docker swarm join-token manager
```

Run the output command on the new manager nodes.

## Step 4: Verify the Cluster

On any manager:

```bash
docker node ls
```

Shows all nodes with status and availability.

## Node Availability

- **Active**: normal scheduling.
- **Pause**: no new tasks, existing tasks continue.
- **Drain**: no new tasks, existing tasks are rescheduled.

Drain a node for maintenance:

```bash
docker node update --availability drain <node-name>
```

## Promoting/Demoting Nodes

```bash
docker node promote <node>   # worker → manager
docker node demote <node>    # manager → worker
```

## Leaving the Swarm

```bash
docker swarm leave           # on a worker
docker swarm leave --force   # on a manager
```

## Multi‑Manager Best Practices

- Use an odd number of managers (3 is minimum for HA).
- Distribute managers across different physical hosts/racks.
- Monitor manager health.

## Persistent State

Swarm stores its state in `/var/lib/docker/swarm/`. Back up this directory on manager nodes.

## Example Setup Script

```bash
# On manager1
docker swarm init --advertise-addr 192.168.1.10
# Store join tokens
docker swarm join-token worker > worker-join
docker swarm join-token manager > manager-join
# On workers
ssh worker1 'bash -s' < worker-join
ssh worker2 'bash -s' < worker-join
```

> 🔗 Next: [Services and Stacks](services-and-stacks.md)
