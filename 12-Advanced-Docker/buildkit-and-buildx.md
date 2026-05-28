# BuildKit & Docker Buildx

BuildKit is a modern builder backend that improves performance, security, and adds features like secrets, cache mounts, and multi-platform builds. `buildx` is a CLI plugin that uses BuildKit.

## Enabling BuildKit

Set the environment variable:

```bash
export DOCKER_BUILDKIT=1
```

Or in Docker daemon config:

```json
{
  "features": { "buildkit": true }
}
```

## BuildKit Features

- **Parallel stage builds**: stages with no dependencies run concurrently.
- **Build secrets**: mount secrets without leaving them in the image.
- **SSH forwarding**: use SSH keys during build.
- **Cache mounts**: persist package caches across builds.
- **Output customization**: export to tar, OCI, or push directly to registry.

## Using Buildx

Buildx is included with Docker Desktop. On Linux, install the plugin:

```bash
docker buildx create --use
```

### Common Commands

```bash
docker buildx build -t myapp:latest --load .        # load to local Docker
docker buildx build -t myapp:latest --push .        # push to registry
docker buildx build --platform linux/amd64,linux/arm64 -t myapp:latest --push .
```

## Build Secrets Example

```bash
docker buildx build --secret id=mytoken,src=./token.txt -t myapp .
```

Dockerfile:

```dockerfile
# syntax=docker/dockerfile:1
RUN --mount=type=secret,id=mytoken cat /run/secrets/mytoken
```

## Cache Mounts

Persist package manager caches to speed up builds:

```dockerfile
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && apt-get install -y gcc
```

## Builder Instances

- `docker buildx ls` – list builders.
- `docker buildx create --name mybuilder --driver docker-container --use` – create a new builder with container driver.
- The container driver allows multi‑arch builds.

## Output Types

- `--output=type=oci,dest=image.tar` – export as OCI tar.
- `--output=type=registry` (default with `--push`).
- `--output=type=docker` – load into local images (default with `--load`).

## Inspecting Builds

`docker buildx du` – disk usage by BuildKit cache.
`docker buildx prune` – clean up build cache.

> 📘 Next: [Multi‑Arch Images](multi-arch-images.md)
