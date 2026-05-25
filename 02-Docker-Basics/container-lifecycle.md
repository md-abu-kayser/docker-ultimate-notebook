# Container Lifecycle – From Creation to Deletion

Understanding the full lifecycle of a container helps you design robust applications and debug issues.

## The Lifecycle States

```
                   +-----------+
                   |  created  |  (docker create)
                   +-----+-----+
                         |
                         v
                   +-----+-----+
                   |  running  |  (docker start / docker run)
                   +-----+-----+
                      |   |   |
          pause/unpause |   | stop / kill
                      v   v
+--------+   +----------+  +---------+
| paused |   | restart  |  | stopped |
+--------+   +----------+  +---------+
                         |
                         v
                   +-----+-----+
                   |  removed  |  (docker rm)
                   +-----------+
```

## Detailed States

1. **Created** – container has been created but never started. No processes run.

   ```bash
   docker create --name my-container ubuntu sleep 100
   ```

2. **Running** – container’s main process (PID 1) is executing.

   ```bash
   docker start my-container
   ```

3. **Paused** – all processes are frozen (SIGSTOP). Memory stays allocated, but no CPU cycles consumed.

   ```bash
   docker pause my-container
   docker unpause my-container
   ```

4. **Stopped** – main process exited or was stopped. The filesystem remains (writable layer intact) until removal.

   ```bash
   docker stop my-container   # graceful (SIGTERM, then SIGKILL after timeout)
   docker kill my-container   # immediate SIGKILL
   ```

5. **Restarting** – transition from stopped to running (e.g., with `--restart=always` policy).

6. **Removed** – container and its writable layer are permanently deleted.
   ```bash
   docker rm my-container
   ```

## Exit Codes

Containers exit with the return code of their main process.

- `0` – success.
- non‑zero – application error.
  View exit code: `docker ps -a --format "table {{.Names}}\t{{.Status}}"`
  Or inspect: `docker inspect <container> --format '{{.State.ExitCode}}'`

## Restart Policies

Specify behaviour when container exits or Docker daemon restarts:

```bash
docker run --restart=always ...
```

Available policies:

- `no` – do not restart (default).
- `on-failure[:max-retries]` – restart only on non‑zero exit.
- `always` – always restart (unless explicitly stopped).
- `unless-stopped` – always restart, except when manually stopped (survives daemon restart).

## Lifecycle Events in Practice

Run an ephemeral container and observe state changes:

```bash
docker run -d --name demo nginx:alpine
docker ps        # running
docker stop demo
docker ps -a     # exited
docker start demo
docker rm -f demo
```

## Cleanup Strategy

Use `--rm` flag during `docker run` to auto‑delete on exit:

```bash
docker run --rm ubuntu echo "I will vanish"
```

Schedule periodic pruning:

```bash
docker container prune -f --filter "until=24h"
```

> 🔗 Next: [Port Mapping](port-mapping.md)
