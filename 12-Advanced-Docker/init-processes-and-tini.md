# Init Processes & tini

The process running as PID 1 inside a container has special responsibilities: handling signals and reaping zombie processes.

## The PID 1 Problem

- PID 1 is expected to forward signals to child processes.
- PID 1 should also reap orphaned zombie processes.
- Many applications (Node.js, Python) are not designed to be init processes.

## Docker’s `--init` Flag

Docker can inject a lightweight init process (`docker-init`) as PID 1.

```bash
docker run --init myapp
```

This `docker-init` (based on `tini`) properly handles signals and zombie reaping.

## Using tini Directly

Install tini in your Dockerfile:

```dockerfile
# Use tini as an init
ADD https://github.com/krallin/tini/releases/download/v0.19.0/tini /usr/local/bin/tini
RUN chmod +x /usr/local/bin/tini
ENTRYPOINT ["/usr/local/bin/tini", "--"]
CMD ["your-app"]
```

Or from package manager:

```dockerfile
FROM ubuntu:22.04
RUN apt-get update && apt-get install -y tini
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/your-app"]
```

## Zombie Process Demonstration

Without an init, a child process that dies becomes a zombie until the parent reaps it. tini does that automatically.

## Signals Handling

tini forwards signals like SIGTERM to the child process, ensuring graceful shutdown.

## When to Use `--init` or tini

- Apps that spawn multiple processes (e.g., bash scripts).
- Apps that do not handle signals properly.
- Always recommended unless your application is designed to run as PID 1 (like Nginx, but even then it’s safe).

## In Compose

```yaml
services:
  app:
    image: myapp
    init: true
```

## Swarm Note

In Swarm mode, the `--init` flag is not directly supported on services, but you can use tini in the image.

> 📘 Next: [Docker API & SDKs](docker-api-and-sdks.md)
