# Backup & Restore for Docker

Data persistence in containers requires explicit backup strategies, especially for databases and volumes.

## 1. Volume Backup

### Named Volume Backup

```bash
docker run --rm \
  -v my_volume:/data \
  -v $(pwd)/backup:/backup \
  alpine tar czf /backup/backup-$(date +%Y%m%d).tar.gz -C /data .
```

### Restore

```bash
docker run --rm \
  -v my_volume:/data \
  -v $(pwd)/backup:/backup \
  alpine tar xzf /backup/backup-20240315.tar.gz -C /data
```

## 2. Database Backup

Use the database’s native tools in a sidecar container.

### PostgreSQL Example

```yaml
services:
  db:
    image: postgres:15
    volumes:
      - pgdata:/var/lib/postgresql/data
    environment:
      POSTGRES_PASSWORD: secret

  backup:
    image: postgres:15
    volumes:
      - pgdata:/data
      - ./backups:/backups
    environment:
      PGPASSWORD: secret
    command: >
      sh -c "pg_dump -h db -U postgres mydb > /backups/backup.sql"
```

Schedule this with a cron job or a dedicated backup container that runs `pg_dump` periodically.

## 3. Swarm Config and Secret Backup

Swarm configs and secrets are stored encrypted in the swarm raft log. The raft log itself (in `/var/lib/docker/swarm`) should be backed up from a manager node.

## 4. Full Host Backup

If using bind mounts, include those directories in your host backup.

## 5. Off‑Site Storage

Copy backups to cloud object storage (S3, GCS) or a remote server. Tools like `rclone` are helpful.

## Backup Best Practices

- Automate backups; never rely on manual runs.
- Test restore procedures regularly.
- Encrypt backups containing sensitive data.
- Monitor backup jobs (alert on failure).

## Restore Strategy

- Stop the application (or at least the database).
- Restore data to a new volume.
- Start a new container with the restored volume.
- Validate data integrity.

## Immutable Backups

Use snapshot‑aware filesystems (ZFS, Btrfs) or volume drivers that support snapshots for consistent backups without stopping containers.

> 📘 Next: [Capacity Planning](capacity-planning.md)
