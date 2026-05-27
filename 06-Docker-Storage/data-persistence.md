# Data Persistence Strategies

Containers are ephemeral; data that must survive must be stored outside the container’s writable layer.

## 1. Named Volumes (Recommended)

- Managed by Docker, portable, easy to backup.
- Best for databases, uploads, stateful applications.
- Use `docker volume create` and `-v` / `--mount`.

## 2. Bind Mounts

- Direct host directory mapping.
- Ideal for development (code sync) and configuration.
- Not portable; paths must exist on every host.

## 3. External Storage Plugins

- Docker volume plugins allow using cloud block storage (EBS, Azure Disk, GCE Persistent Disk), NFS, Ceph, etc.
- Examples: `rexray/ebs`, `portworx/pxd`.
- Enable containers to be scheduled on any node and still access the same volume (requires Swarm/Kubernetes).

## Database Persistence Patterns

- Run database engine in a container but mount data to a named volume.
- Take regular backups using native tools (`pg_dump`) and store off‑host.
- Use sidecar containers for automated backups.

### Example: PostgreSQL with volume and backup sidecar

```yaml
services:
  db:
    image: postgres:15
    volumes:
      - db_data:/var/lib/postgresql/data
  backup:
    image: postgres:15
    volumes:
      - db_data:/data
      - ./backups:/backups
    command: >
      sh -c "pg_dump -h db -U postgres mydb > /backups/backup.sql"
```

## Handling Secrets and Configs

- Use bind mounts or Docker secrets (Swarm) for sensitive files.
- Do not bake credentials into images.

## Stateful vs Stateless Services

- Stateless: can be scaled, restarted anywhere, no need for persistence.
- Stateful: requires persistence and careful lifecycle management (volumes, backups, replicas).

## Backup Strategies

1. **Volume backup**: stop container, backup volume data.
2. **Application‑level backup**: use DB tools, then store backup in cloud.
3. **Snapshot**: if using ZFS/btrfs volume driver, take filesystem snapshots.

## Restoring Data

Always test restore procedures. For volumes:

```bash
docker run --rm -v new_volume:/data -v ./backup:/backup alpine tar xzf /backup/backup.tar.gz -C /data
```

> 🎉 Congratulations! You’ve completed the **Docker Storage** section.

> 📘 Ready to dive in? Head over to **07‑Docker‑Security** starting with [Volumes vs Bind Mounts](../07-Docker-Security/security-best-practices.md)
