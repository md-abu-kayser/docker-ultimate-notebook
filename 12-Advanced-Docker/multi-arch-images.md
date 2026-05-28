# Multi‑Architecture Docker Images

Containers must match the host’s CPU architecture. Multi‑arch images let you build one image name that works on `amd64`, `arm64`, etc.

## Manifest Lists

A manifest list (or fat manifest) is a list of references to platform‑specific image manifests. Docker automatically selects the correct one based on the host architecture.

## Building Multi‑Arch Images with Buildx

```bash
docker buildx create --use
docker buildx build \
  --platform linux/amd64,linux/arm64,linux/arm/v7 \
  -t myapp:latest \
  --push .
```

This pushes a manifest list with all three architectures.

## Without Pushing (local)

To load multi‑arch images locally, you must export to a Docker archive for each architecture separately, or use a registry.

```bash
docker buildx build --platform linux/amd64 -t myapp:amd64 --load .
docker buildx build --platform linux/arm64 -t myapp:arm64 --load .
```

Then create a manifest list manually:

```bash
docker manifest create myapp:latest \
  myapp:amd64 \
  myapp:arm64
docker manifest push myapp:latest
```

## Inspecting a Manifest List

```bash
docker buildx imagetools inspect myapp:latest
```

Shows all platforms and digests.

## Dockerfile Considerations

- Use multi‑stage builds to avoid platform‑specific commands.
- Use `ARG TARGETARCH` to run architecture‑dependent logic:
  ```dockerfile
  FROM --platform=$BUILDPLATFORM golang:1.21 AS builder
  ARG TARGETARCH
  RUN GOARCH=$TARGETARCH go build -o myapp .
  ```
- Use `--platform` flag in `FROM` to pin specific stages.

## CI/CD Integration

In GitHub Actions, use `docker/setup-buildx-action` and build with multiple platforms, then push.

## Cross‑Compilation vs Emulation

- Buildx can use QEMU emulation to build for different architectures. Enable it:
  ```bash
  docker run --privileged --rm tonistiigi/binfmt --install all
  ```
- Cross‑compilation inside the Dockerfile is faster and doesn’t require QEMU if your language supports it (Go, Rust).

## Best Practices

- Always build for both amd64 and arm64 to support Apple Silicon and cloud ARM instances.
- Push to a registry; don’t rely on local images for multi‑arch.
- Test images on each architecture.

> 📘 Next: [Resource Limits & cgroups](resource-limits-cgroups.md)
