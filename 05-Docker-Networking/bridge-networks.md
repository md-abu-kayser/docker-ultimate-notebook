# Bridge Networks

Bridge networks are the most common driver for containers running on a single host.

## Default Bridge vs User‑Defined Bridge

| Feature        | Default Bridge                                    | User‑Defined Bridge                                                   |
| -------------- | ------------------------------------------------- | --------------------------------------------------------------------- |
| DNS resolution | No (only IP)                                      | Automatic service name resolution                                     |
| Isolation      | Containers can communicate if linked (deprecated) | Better isolation; only containers on the same network can communicate |
| Configuration  | None                                              | Custom subnets, IP ranges                                             |
| Use case       | Legacy, simple                                    | All modern applications                                               |

**Always create a user‑defined bridge.**

## Creating a Bridge Network

```bash
docker network create --driver bridge mynet
docker network create --subnet=192.168.100.0/24 --gateway=192.168.100.1 mynet
```

## Connecting Containers

```bash
docker run -d --name web --network mynet nginx:alpine
docker run -it --network mynet alpine sh
```

From inside the alpine container, `ping web` works because Docker’s embedded DNS resolves the service name.

## Port Publishing on Bridge

Traffic from the outside reaches the container via NAT:

```
Host IP:8080 → Docker proxy → bridge gateway → container IP:80
```

## Inspecting the Bridge

```bash
docker network inspect mynet
```

Shows subnet, gateway, connected containers with IPs.

## Disconnecting Containers

```bash
docker network disconnect mynet web
docker network connect mynet web
```

You can attach a container to multiple networks.

## Best Practices

- Use one bridge per application stack.
- Avoid the default bridge.
- Limit inter‑container communication by using separate networks for frontend and backend.

> 🔗 Next: [Overlay Networks](overlay-networks.md)
