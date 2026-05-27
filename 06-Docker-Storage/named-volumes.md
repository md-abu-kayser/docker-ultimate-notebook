# Named Volumes

Named volumes are the primary way to persist and share data among containers.

## Creating a Named Volume

```bash
docker volume create app-data
```

Optionally specify a driver and options:

```bash
docker volume create --driver local --opt type=tmpfs --opt device=tmpfs --opt o=size=100m tmp-data
```

## Listing and Inspecting

```bash
docker volume ls
docker volume inspect app-data
```

Inspect shows mountpoint on the host (e.g., `/var/lib/docker/volumes/app-data/_data`).

## Using Volumes in Containers

```bash
docker run -d -v app-data:/usr/share/nginx/html nginx:alpine
```

## Sharing a Volume Between Containers

```bash
docker run -d --name writer -v shared:/data alpine tail -f /dev/null
docker run --rm -it -v shared:/data alpine sh
```

Both containers see the same files.

## Backing Up a Volume

```bash
docker run --rm -v app-data:/data -v $(pwd):/backup alpine tar czf /backup/app-data-backup.tar.gz -C /data .
```

## Restoring a Volume

```bash
docker run --rm -v app-data:/data -v $(pwd):/backup alpine tar xzf /backup/app-data-backup.tar.gz -C /data
```

## Removing Volumes

```bash
docker volume rm app-data
docker volume prune   # remove unused volumes
```

Volumes are not deleted when a container is removed unless you use `docker rm -v` or `docker compose down -v`.

## Volume Drivers

Plugins enable remote storage (e.g., AWS EBS, NFS, Ceph). Example with `vieux/sshfs`:

```bash
docker volume create --driver vieux/sshfs -o sshcmd=user@host:/remote/path -o password=secret myvolume
```

> 🔗 Next: [tmpfs Mounts](tmpfs-mounts.md)
