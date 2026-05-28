# Resource Limits & cgroups

Linux control groups (cgroups) allow you to limit and monitor resources used by containers. Without limits, a container can exhaust host resources.

## CPU Limits

### `--cpus` (or `--cpuset-cpus`)

Specifies how much CPU a container can use.

```bash
docker run --cpus="1.5" myapp   # 1.5 CPU cores
```

### CPU Shares (`--cpu-shares`)

Relative weight (default 1024). Only effective under contention.

```bash
docker run --cpu-shares=512 myapp
```

### CPU Period and Quota (advanced)

`--cpu-period` and `--cpu-quota` define CFS scheduler limits.

## Memory Limits

### `--memory` (or `-m`)

Limit container memory usage.

```bash
docker run --memory="256m" --memory-swap="512m" myapp
```

- `--memory`: hard limit.
- `--memory-swap`: total memory+swap; set to `-1` for unlimited swap, or equal to memory to disable swap.

### OOM Killer

If a container exceeds the memory limit, the kernel OOM killer terminates processes. Use `--oom-kill-disable` to prevent killing (container will hang instead).

## Block I/O Limits

### `--blkio-weight` (relative weight)

```bash
docker run --blkio-weight 500 myapp
```

### Direct throttling

`--device-read-bps`, `--device-write-bps`, `--device-read-iops`, `--device-write-iops`.

## PIDs Limit

Limit number of processes inside a container:

```bash
docker run --pids-limit=100 myapp
```

Prevents fork bombs.

## Setting Limits in Compose

```yaml
services:
  app:
    deploy:
      resources:
        limits:
          cpus: "0.5"
          memory: 256M
        reservations:
          cpus: "0.25"
          memory: 128M
```

In Swarm mode, `deploy.resources` works. For Compose without Swarm, use `--compatibility` flag or version 2 syntax.

## Checking Resource Usage

- `docker stats` – live stats.
- `docker inspect <container>` – limit configurations.

## Best Practices

- Always set memory limits in production.
- Reserve memory and CPU for critical services.
- Use cgroups v2 for better resource management.

> 📘 Next: [Init Processes & tini](init-processes-and-tini.md)
