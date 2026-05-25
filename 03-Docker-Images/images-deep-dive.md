# Docker Images – Deep Dive

Docker images are the blueprint for containers. Understanding their internals helps you build secure, efficient, and portable applications.

## What Exactly Is an Image?

An image is a **read-only template** composed of multiple layers, plus metadata (environment variables, default command, ports, etc.). It’s built according to the **OCI (Open Container Initiative) Image Specification**.

## Image Manifests

A manifest is a JSON file that describes the image. It contains:

- Image configuration (architecture, OS, environment, entrypoint).
- List of layer descriptors (digests, sizes).

Example (simplified):

```json
{
  "schemaVersion": 2,
  "mediaType": "application/vnd.docker.distribution.manifest.v2+json",
  "config": {
    "mediaType": "application/vnd.docker.container.image.v1+json",
    "size": 7023,
    "digest": "sha256:abc123..."
  },
  "layers": [
    {
      "mediaType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
      "size": 32654,
      "digest": "sha256:def456..."
    }
  ]
}
```

When you pull an image, Docker fetches the manifest, then downloads the config and layer blobs.

## Image Layers

- Each instruction in a Dockerfile creates a new layer.
- Layers are **content-addressed** – identified by a SHA256 digest.
- They are stacked using a union filesystem (Overlay2) to form the container’s root filesystem.
- Layers are shared across images, saving disk space.

## Tags and Digests

- A **tag** (e.g., `nginx:1.25`) is a mutable pointer to a specific image manifest.
- A **digest** (`nginx@sha256:ab...`) is an immutable identifier of the exact manifest content.
- Always use digests in production to guarantee immutability.

## Image Registries

- `docker pull alpine` is shorthand for `docker pull docker.io/library/alpine:latest`.
- Registries are hierarchical: `registry/namespace/repository:tag`.
- The default registry is Docker Hub.
- You can run a private registry (e.g., `registry:2`).

## Pulling, Inspecting, and Saving

```bash
docker pull nginx:alpine
docker image inspect nginx:alpine    # full metadata JSON
docker save -o nginx.tar nginx:alpine
docker load -i nginx.tar
```

## Image Distribution

Images are distributed as compressed tar archives, with each layer being a tar file. Docker Hub serves them via a REST API.

## OCI Image vs Docker Image

Docker images conform to the OCI specification, ensuring compatibility with other container runtimes like Podman and containerd.

> 🔗 Next: [Dockerfile Basics](dockerfile-basics.md)
