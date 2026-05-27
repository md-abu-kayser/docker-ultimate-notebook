# Volumes vs Bind Mounts

Docker offers two main ways to persist data: volumes and bind mounts.

## Volumes

- Managed by Docker (`/var/lib/docker/volumes/` on Linux).
- Can be named or anonymous.
- Portable across different hosts (using drivers).
- Decoupled from host filesystem structure.
- Best for persistent application data (databases, uploads).

### Creating and Using a Named Volume

```bash
docker volume create mydata
docker run -v mydata:/app/data myimage
```

## Bind Mounts

- Mount a specific host directory or file into the container.
- Path is absolute (or relative to current working directory with `./`).
- Useful for development (live code reloading) or sharing config files.

```bash
docker run -v /host/path:/container/path myimage
docker run -v ./config:/etc/app/config myimage
```

## Key Differences

| Feature     | Volumes                                   | Bind Mounts                          |
| ----------- | ----------------------------------------- | ------------------------------------ |
| Location    | Docker area (host independent)            | Host filesystem (specific path)      |
| Management  | docker volume commands                    | Directly by user                     |
| Portability | Yes (with drivers)                        | No (host‑dependent)                  |
| Performance | Native, optimized                         | Slightly slower (depends on OS)      |
| Use case    | Production data, sharing among containers | Development, configuration injection |

## When to Use Which

- **Volumes** for everything that needs to survive container lifecycle and be managed by Docker.
- **Bind Mounts** for development hot reload, sharing SSH keys, or mounting configuration files that must be edited on the host.

## Syntax with `--mount` (more explicit)

```bash
docker run --mount type=volume,source=mydata,target=/app/data ...
docker run --mount type=bind,source="$(pwd)"/config,target=/etc/app/config ...
```

`--mount` is the recommended way over `-v` for clarity.

> 🔗 Next: [Named Volumes](named-volumes.md)
