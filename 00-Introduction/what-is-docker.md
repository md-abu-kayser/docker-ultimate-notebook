# What is Docker?

Docker is a platform for **developing, shipping, and running applications** inside lightweight, portable containers.

## Containerization

Containers bundle an application with **all its dependencies** (libraries, binaries, configuration) into a single unit.  
This ensures the software runs exactly the same, regardless of the underlying environment.

## Key Benefits

- **Consistency:** No more “it works on my machine”.
- **Speed:** Containers start in seconds (vs. minutes for VMs).
- **Efficiency:** Share the host OS kernel, consume far fewer resources.
- **Portability:** Run anywhere – laptop, data center, cloud.
- **Microservices ready:** Perfect for building distributed systems.

## Docker Engine

The core component that creates and runs containers. It consists of:

- **Docker Daemon (`dockerd`)** – manages images, containers, networks, and volumes.
- **Docker Client (`docker`)** – CLI tool to interact with the daemon via REST API.

## How it works under the hood

Docker uses Linux kernel features:

- **Namespaces** – isolate processes (PID, NET, IPC, MNT, UTS, USER).
- **Control Groups (cgroups)** – limit and monitor resources.
- **Union File Systems (OverlayFS)** – efficient image layering.

Docker is not a virtual machine; it’s OS‑level virtualization.

> 📘 Next: [Why Docker?](why-docker.md)
