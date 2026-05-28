# Podman & Docker Alternatives

Docker isn’t the only container runtime. Several alternatives have emerged, each with distinct advantages.

## Podman

- **Daemonless**: doesn’t require a background service; containers run directly as child processes.
- **Rootless by default**: improved security.
- **Docker‑compatible CLI**: `alias docker=podman` works for most commands.
- **Pods**: can group containers like Kubernetes pods.
- **Docker Compose support**: `podman-compose` or native `podman play kube`.

Pros: Better security, no daemon overhead, easy Kubernetes integration.
Cons: Slightly different networking, some Docker features missing (Swarm).

## Buildah

- Companion to Podman for building images.
- Can build OCI images without a daemon.
- Often used in CI where rootless operation is beneficial.

## containerd

- Industry‑standard container runtime, used by Docker and Kubernetes.
- Lower‑level, not directly user‑friendly; typically used with `ctr` or `crictl`.

## Kaniko

- Builds container images in environments without a Docker daemon (e.g., Kubernetes pods).
- Executes each Dockerfile instruction in user space.

## Singularity (Apptainer)

- Designed for HPC and scientific computing.
- Runs containers as the current user, no root escalation.

## Comparison Table

| Tool       | Daemon | Rootless            | Compose Support      | K8s Integration          |
| ---------- | ------ | ------------------- | -------------------- | ------------------------ |
| Docker     | Yes    | Yes (rootless mode) | Yes (v2)             | Yes (via Docker Desktop) |
| Podman     | No     | Yes (default)       | Yes (podman-compose) | Yes (pods, play kube)    |
| containerd | Yes    | Possible with ctr   | No                   | Native (CRI)             |
| Kaniko     | No     | N/A                 | No                   | Used inside K8s          |

## When to Consider Alternatives

- Security‑sensitive environments: Podman.
- CI/CD pipelines without Docker access: Kaniko.
- Kubernetes‑only shops: containerd (via crictl) already available.
- HPC: Apptainer.

## The Future of Container Runtimes

OCI specifications have standardized image and runtime formats, so images work across Docker, Podman, containerd, and Kubernetes.

> 🎉 Congratulations! You’ve completed the **Beyond Docker** section.

> 📘 Ready to dive in? Head over to **99‑Cheatsheets** starting with [Docker CLI Cheatsheet](../99-Cheatsheets/docker-cli-cheatsheet.md)
