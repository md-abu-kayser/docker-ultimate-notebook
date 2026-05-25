# Docker Images and Containers – The Core Concepts

## What Is a Docker Image?

A **Docker image** is a lightweight, standalone, executable package that includes everything needed to run a piece of software: code, runtime, system tools, libraries, and settings.

- Images are **read‑only templates**.
- Built from a series of **layers**, each representing an instruction in a Dockerfile.
- Identified by a repository name, a tag, and a digest (e.g., `nginx:1.25-alpine@sha256:...`).

### Image Layering

```
Layer 1: Base OS (alpine)
Layer 2: Install nginx package
Layer 3: Add configuration file
Layer 4: Set environment variable
```

When you run an image, a thin writable **container layer** is added on top. All changes during container runtime go into that layer.

## What Is a Docker Container?

A **container** is a runnable instance of an image. It’s an isolated process (or group of processes) with its own filesystem, network, and PID space.

Key properties:

- **Isolated** from the host and other containers.
- **Ephemeral by design** – when deleted, the writable layer is lost (unless you use volumes).
- **Stateful** only if you explicitly persist data.

### Container = Image + writable layer + runtime configuration

## Image vs Container – A Mental Model

Think of an image as a **class** in object‑oriented programming, and a container as an **object** instantiated from that class. You can create many containers from one image.

## Pulling and Listing Images

```bash
# Pull an image from Docker Hub
docker pull alpine:3.18

# List locally available images
docker images
# or
docker image ls
```

Output shows repository, tag, image ID, size.

## Running a Container

```bash
docker run -it alpine:3.18 sh
```

- `-i` – interactive, keep STDIN open.
- `-t` – allocate a pseudo‑TTY.
- `sh` – command to run inside the container.

You now have a shell inside an Alpine Linux container. Type `exit` to leave; the container will stop.

## Inspecting Images and Containers

- `docker inspect <image/container>` – JSON with all details (layers, networks, mounts).
- `docker history <image>` – shows each layer command and size.

## Tagging and Versioning

Images can have multiple tags:

```bash
docker tag alpine:3.18 myrepo/alpine:latest
```

Tagging is crucial for version control and deployment. Always avoid `:latest` in production.

## Saving and Loading Images

Export an image as a tar file:

```bash
docker save -o alpine.tar alpine:3.18
```

Load it on another machine:

```bash
docker load -i alpine.tar
```

## Removing Images and Containers

```bash
docker rmi <image>       # remove image (must not have running containers)
docker rm <container>    # remove a stopped container
docker container prune   # remove all stopped containers
docker image prune       # remove dangling images
```

> 📘 Next: [Your First Container](your-first-container.md)
