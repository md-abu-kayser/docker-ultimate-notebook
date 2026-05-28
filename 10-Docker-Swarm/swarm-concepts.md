# Docker Swarm Concepts

Docker Swarm is Docker’s native clustering and orchestration tool. It turns a pool of Docker hosts into a single virtual host.

## Core Components

### Nodes

- **Manager nodes**: maintain cluster state, schedule services, handle API requests.
- **Worker nodes**: run tasks assigned by managers.
- A cluster can have multiple managers for high availability (Raft consensus).

### Services

- The definition of a desired state for a containerized application.
- Two modes:
  - **Replicated**: run a specified number of identical tasks.
  - **Global**: one task on every node.

### Tasks

- The atomic unit of scheduling. A task is a container plus the command to run.
- If a task fails, Swarm reschedules it.

### Stacks

- A group of interrelated services defined in a Compose file.
- Deployed using `docker stack deploy`.

### Load Balancing

- **Routing mesh**: every node in the swarm can route traffic to any running task for a published port.
- Internal DNS resolution for service‑to‑service communication.

### Overlay Network

- Multi‑host networking via VXLAN tunnels.
- Enables containers across different nodes to communicate seamlessly.

## Why Swarm?

- Simple setup and operations (compared to Kubernetes).
- Tight integration with Docker CLI and Compose.
- Secure by default (TLS mutual authentication, encrypted control plane).
- Built‑in load balancing and service discovery.

## Swarm Mode CLI

```bash
docker swarm init           # create a new swarm (first manager)
docker swarm join           # join as worker or manager
docker node ls              # list nodes
docker service create       # create a service
docker stack deploy         # deploy a stack
```

## Raft Consensus

- Manages the cluster state.
- A majority of managers must be available (N/2+1).
- Odd number of managers recommended (3, 5, 7).

## Security in Swarm

- PKI (Public Key Infrastructure) with automatic certificate rotation.
- Control plane encrypted with TLS.
- Secrets and configs encrypted at rest and in transit.

> 🔗 Next: [Cluster Setup](cluster-setup.md)
