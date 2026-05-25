# Docker Architecture

Understanding the components that make Docker tick is essential for troubleshooting and performance tuning.

## High‑Level Overview

Docker uses a **client‑server architecture**. The Docker client talks to the Docker daemon, which does the heavy lifting of building, running, and distributing containers.

```
CLIENT (docker CLI)  <-- REST API -->  DAEMON (dockerd)  <-- containerd -->  CONTAINERS
```

## Core Components

### Docker Daemon (`dockerd`)

- Listens for API requests and manages Docker objects (images, containers, networks, volumes).
- Can communicate with other daemons in Swarm mode.
- Runs on the host machine.

### Docker Client (`docker`)

- The primary user interface. Sends commands to the daemon via the Unix socket (`/var/run/docker.sock`) or TCP.
- One client can talk to multiple daemons (e.g., `docker -H tcp://remote:2375`).

### Docker Registry

- Stores Docker images. **Docker Hub** is the default public registry.
- You can run a private registry.
- `docker pull` and `docker push` interact with registries.

### containerd & runc

- `containerd` manages the full container lifecycle: image push/pull, container execution, network management.
- `runc` is the low‑level OCI runtime that actually creates and runs containers using Linux kernel primitives.

## Under the Hood: How Containers Are Isolated

Docker leverages three key Linux kernel features:

1. **Namespaces** – Isolate what a process can _see_.
   - PID: process tree isolation.
   - NET: separate network stack.
   - MNT: filesystem mount points.
   - UTS: hostname and domain name.
   - IPC: inter‑process communication.
   - USER: maps UIDs inside container to host.

2. **Control Groups (cgroups)** – Limit what a process can _use_.
   - CPU shares, memory limits, block I/O.
   - Ensures fairness and prevents noisy neighbours.

3. **Union Filesystems (Overlay2)** – Efficient image layering.
   - Images are composed of read‑only layers; a writable container layer sits on top.
   - Copy‑on‑write saves storage and speeds up startup.

## Docker Objects

| Object        | Description                                                                                  |
| ------------- | -------------------------------------------------------------------------------------------- |
| **Image**     | Read‑only template with instructions to create a container. Built from Dockerfiles.          |
| **Container** | A runnable instance of an image. You can start, stop, move, or delete it.                    |
| **Network**   | Virtual networks that allow containers to communicate with each other and the outside world. |
| **Volume**    | Persistent data storage independent of the container lifecycle.                              |
| **Plugin**    | Extends Docker’s functionality (e.g., storage, networking, authorization).                   |

## Data Flow During a `docker run` Command

1. Client sends `docker run` to daemon.
2. Daemon checks if the image exists locally; if not, pulls from registry.
3. Daemon creates a writable container layer over the image.
4. Allocates IP address from the network.
5. Starts the process specified in the image (PID 1 inside the container).
6. Attaches STDOUT/STDERR to the client.

## Visualizing the Stack

```
┌──────────────────────────────────────────────┐
│                   Docker CLI                 │
└──────────────────────┬───────────────────────┘
                       │ REST API
┌──────────────────────▼───────────────────────┐
│              dockerd (Daemon)                │
│   ┌──────────────────────────────────────┐   │
│   │            containerd                │   │
│   │   ┌──────────────────────────────┐   │   │
│   │   │         runc (OCI)            │   │   │
│   │   │   Container 1, Container 2 … │   │   │
│   │   └──────────────────────────────┘   │   │
│   └──────────────────────────────────────┘   │
└──────────────────────────────────────────────┘
```

> 🔗 Next: [Docker Images and Containers](images-and-containers.md)
