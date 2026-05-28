# Docker CLI Quick Reference

## Images

```bash
docker pull <image>            # Pull image
docker push <image>            # Push image
docker images                  # List local images
docker rmi <image>             # Remove image
docker tag <src> <tgt>         # Tag image
docker build -t <name> .       # Build from Dockerfile
docker history <image>         # Image layers
docker save/load               # Export/import tar
```

## Containers

```bash
docker run <image>             # Create & start
docker run -d -p H:C --name N <image>
docker ps / ps -a              # List running/all
docker stop/start/restart <c>  # Lifecycle
docker rm <c>                  # Remove
docker exec -it <c> <cmd>      # Run command inside
docker logs <c>                # Show logs
docker inspect <c>             # Detailed info
docker top <c>                 # Processes
docker stats                   # Resource usage
docker cp <c>:path hostpath    # Copy files
```

## System

```bash
docker info                    # System info
docker system df               # Disk usage
docker system prune -a         # Remove unused data
docker login/logout            # Registry auth
```

## Networks

```bash
docker network ls
docker network create <name>
docker network connect/disconnect
```

## Volumes

```bash
docker volume ls
docker volume create <name>
docker volume inspect
docker volume prune
```

## Swarm

```bash
docker swarm init
docker swarm join
docker node ls
docker service create/update/scale/rm
docker stack deploy -c file.yml stack
```

## Useful Flags

`-d` detach, `-it` interactive TTY, `--rm` auto‑remove, `-e` env var, `-v` volume, `--name` name, `--restart` policy, `--network`, `--cap-add/drop`, `--read-only`, `--init`.

> 📘 Next: [Dockerfile Cheatsheet](dockerfile-cheatsheet.md)
