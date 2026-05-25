# Essential Docker Commands

This reference covers the most common Docker CLI commands you’ll use daily. Master these, and you’ll be able to manage containers and images efficiently.

## Image Commands

| Command                     | Description                       |
| --------------------------- | --------------------------------- |
| `docker pull <image>`       | Download an image from a registry |
| `docker push <image>`       | Upload an image to a registry     |
| `docker images`             | List local images                 |
| `docker rmi <image>`        | Remove one or more images         |
| `docker tag <src> <target>` | Create a tag for an image         |
| `docker build -t <name> .`  | Build an image from a Dockerfile  |
| `docker history <image>`    | Show the layers of an image       |
| `docker inspect <image>`    | Detailed JSON metadata            |
| `docker save/load`          | Export/import images as tar files |

## Container Commands

| Command                             | Description                             |
| ----------------------------------- | --------------------------------------- |
| `docker run <image>`                | Create and start a container            |
| `docker ps`                         | List running containers                 |
| `docker ps -a`                      | List all containers (including stopped) |
| `docker stop <container>`           | Gracefully stop a running container     |
| `docker start <container>`          | Start a stopped container               |
| `docker restart <container>`        | Stop and start a container              |
| `docker rm <container>`             | Remove a stopped container              |
| `docker exec -it <container> <cmd>` | Run a command in a running container    |
| `docker logs <container>`           | Fetch the logs of a container           |
| `docker inspect <container>`        | Detailed container metadata             |
| `docker top <container>`            | Display running processes inside        |
| `docker stats`                      | Live resource usage of containers       |
| `docker cp <container>:path <host>` | Copy files between host and container   |

## System & Cleanup

| Command                  | Description                                                            |
| ------------------------ | ---------------------------------------------------------------------- |
| `docker info`            | Display system‑wide information                                        |
| `docker system df`       | Show disk usage by images/containers/volumes                           |
| `docker system prune`    | Remove all unused data (stopped containers, networks, dangling images) |
| `docker system prune -a` | Remove everything not associated with a running container              |

## Filters and Formatting

Use `--filter` to narrow output:

```bash
docker ps -a --filter "status=exited"
docker images --filter "dangling=true"
```

Format output with `--format` using Go templates:

```bash
docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}"
```

## Aliases for Speed

Add these to your `.bashrc` or `.zshrc`:

```bash
alias d='docker'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias drm='docker rm'
alias drmi='docker rmi'
```

## Pro Tip: Help System

Never memorise everything; use the built‑in help:

```bash
docker --help
docker run --help
docker container --help
```

Man pages are also available: `man docker-run`.

> 🔗 Next: [Container Lifecycle](container-lifecycle.md)
