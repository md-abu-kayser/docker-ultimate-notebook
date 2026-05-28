# Docker Engine API & SDKs

Docker exposes a REST API that allows programmatic management of containers, images, networks, and more.

## Docker API Overview

- Unix socket: `unix:///var/run/docker.sock` (default).
- TCP with TLS: `tcp://host:2376`.
- API version: `v1.43` (depends on Docker version).

## Enabling Remote API (with caution)

```bash
dockerd -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock
```

⚠️ Without TLS, this is insecure. Always use TLS in production.

## Using cURL

```bash
# List containers
curl --unix-socket /var/run/docker.sock http://localhost/containers/json

# Create a container
curl -X POST --unix-socket /var/run/docker.sock \
  -H "Content-Type: application/json" \
  -d '{"Image": "nginx:alpine"}' \
  http://localhost/containers/create

# Start a container
curl -X POST --unix-socket /var/run/docker.sock \
  http://localhost/containers/<id>/start
```

## Docker SDK for Python

```bash
pip install docker
```

```python
import docker

client = docker.from_env()
# List containers
for container in client.containers.list():
    print(container.name)

# Run a container
container = client.containers.run('nginx:alpine', detach=True, ports={'80/tcp': 8080})

# Build an image
image, logs = client.images.build(path='.', tag='myapp:latest')

# Stream logs
for line in container.logs(stream=True):
    print(line.strip())
```

## Docker SDK for Go

```go
import "github.com/docker/docker/client"
cli, _ := client.NewClientWithOpts(client.FromEnv)
containers, _ := cli.ContainerList(context.Background(), types.ContainerListOptions{})
```

## Use Cases

- Custom orchestration tools.
- Monitoring agents.
- CI/CD integrations.
- Self‑service developer portals.

## Security Warning

Exposing the Docker socket inside a container gives root access to the host. Use with extreme caution, and prefer the API over TCP with TLS.

> 🎉 Congratulations! You’ve completed the **Advanced Docker** section.

> 📘 Ready to dive in? Head over to **13‑Production‑Readiness** starting with [Production Dockerfile](../13-Production-Readiness/production-dockerfile.md)
