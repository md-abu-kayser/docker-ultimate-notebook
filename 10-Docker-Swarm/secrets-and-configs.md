# Secrets & Configs in Docker Swarm

Swarm provides built‑in secret and config management, keeping sensitive data and configuration files out of images.

## Docker Secrets

Secrets are encrypted at rest and in transit, and only mounted into containers that are authorized to access them.

### Creating a Secret

```bash
echo "mydbpassword" | docker secret create db_pass -
```

From a file:

```bash
docker secret create db_pass ./password.txt
```

### Using a Secret in a Service

```bash
docker service create \
  --name db \
  --secret db_pass \
  -e POSTGRES_PASSWORD_FILE=/run/secrets/db_pass \
  postgres
```

### In a Stack

```yaml
services:
  db:
    image: postgres
    secrets:
      - db_pass
    environment:
      POSTGRES_PASSWORD_FILE: /run/secrets/db_pass
secrets:
  db_pass:
    external: true
```

The secret appears as a file at `/run/secrets/db_pass`.

## Docker Configs

Configs are similar to secrets but not encrypted at rest. They’re for non‑sensitive configuration files.

### Creating a Config

```bash
docker config create nginx-conf ./nginx.conf
```

### Using Configs

```yaml
services:
  web:
    image: nginx
    configs:
      - source: nginx-conf
        target: /etc/nginx/conf.d/default.conf
configs:
  nginx-conf:
    external: true
```

## Differences Between Secrets and Configs

| Feature     | Secrets                 | Configs               |
| ----------- | ----------------------- | --------------------- |
| Encryption  | Yes (at rest & transit) | No                    |
| Size limit  | 500 KB (default)        | 500 KB (default)      |
| Mount point | `/run/secrets/`         | User‑defined location |

## Managing Secrets and Configs

```bash
docker secret ls
docker secret inspect db_pass
docker secret rm db_pass

docker config ls
docker config rm nginx-conf
```

## Rotating Secrets

1. Create a new secret (e.g., `db_pass_v2`).
2. Update the service to use the new secret and remove the old:
   ```bash
   docker service update --secret-rm db_pass --secret-add db_pass_v2 mydb
   ```
3. After all tasks restart, delete the old secret.

## Best Practices

- Never hardcode secrets in Compose files or images.
- Use file‑based secrets with applications that support `_FILE` environment variables.
- Rotate secrets regularly.
- Limit access: only services that need a secret should have it.

> 🔗 Next: [Placement and Constraints](placement-and-constraints.md)
