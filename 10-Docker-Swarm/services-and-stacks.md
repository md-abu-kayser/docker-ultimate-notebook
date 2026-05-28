# Services and Stacks in Docker Swarm

Services and stacks are the two primary abstractions for deploying applications on Swarm.

## Docker Service

A service defines the desired state for a group of containers (tasks).

### Creating a Service

```bash
docker service create \
  --name my-web \
  --replicas 3 \
  --publish published=80,target=80 \
  nginx:alpine
```

### Service Modes

- **Replicated**: `--replicas N` (default).
- **Global**: one task per node (`--mode global`).

### Service Management

```bash
docker service ls
docker service ps my-web
docker service inspect my-web
docker service logs my-web
docker service scale my-web=5
docker service update --image nginx:latest my-web
docker service rm my-web
```

## Docker Stack

A stack is a collection of services defined in a Compose file (v3+), deployed as one unit.

### Deploying a Stack

```bash
docker stack deploy -c docker-compose.yml mystack
```

### Stack Commands

```bash
docker stack ls
docker stack services mystack
docker stack ps mystack
docker stack deploy -c docker-compose.yml mystack   # update
docker stack rm mystack
```

## Compose File for Swarm

Use version `3.8` or `3.9`. Some keys are Swarm‑specific:

```yaml
version: "3.8"

services:
  web:
    image: nginx:alpine
    ports:
      - "80:80"
    deploy:
      replicas: 3
      update_config:
        parallelism: 1
        delay: 10s
      restart_policy:
        condition: on-failure
```

- `deploy` section controls Swarm‑specific behavior.
- `configs` and `secrets` are top‑level keys.

## Service Discovery

- Services can reach each other by **service name** (DNS).
- Ingress mesh routes external traffic to any node running the service.

## Updating a Service

```bash
docker service update --replicas 5 --image myapp:v2 myservice
```

Or edit the compose file and redeploy the stack.

## Rollback

```bash
docker service rollback myservice
```

## Constraints and Placement

Control where tasks run:

```bash
docker service create --constraint node.role==worker ...
```

> 🔗 Next: [Networking in Swarm](networking-in-swarm.md)
