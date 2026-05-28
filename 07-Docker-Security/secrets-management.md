# Docker Secrets Management

Hardcoding secrets in images is a major security risk. Docker provides mechanisms to safely handle sensitive data.

## Never Do This

- `ENV DATABASE_PASSWORD=supersecret`
- `COPY .env .` (if it contains secrets)
- Baking API keys in image layers.

## Docker Secrets (Swarm Mode)

Secrets are encrypted during transit and at rest, and only exposed to containers that need them.

### Creating a Secret

```bash
echo "mypassword" | docker secret create db_password -
```

Or from a file:

```bash
docker secret create db_password ./password.txt
```

### Using a Secret in a Service

```yaml
services:
  app:
    image: myapp
    secrets:
      - db_password
    environment:
      - DB_PASSWORD_FILE=/run/secrets/db_password
secrets:
  db_password:
    external: true
```

The secret is mounted as a file at `/run/secrets/db_password`. Your app reads it from that file.

### Listing and Removing

```bash
docker secret ls
docker secret rm db_password
```

## Build‑Time Secrets (BuildKit)

For secrets that are needed during image build (e.g., SSH keys for private repos), use BuildKit:

```bash
DOCKER_BUILDKIT=1 docker build --secret id=mysecret,src=./secret.txt .
```

In Dockerfile:

```dockerfile
# syntax=docker/dockerfile:1
RUN --mount=type=secret,id=mysecret cat /run/secrets/mysecret
```

The secret is not stored in the final image layer.

## Environment‑Based Secrets (Development)

For non‑Swarm setups, you can pass secrets via environment variables but never commit them:

```bash
docker run -e DB_PASSWORD=$(cat ./password.txt) myapp
```

Better: use `--env-file` with a file that is in `.gitignore`.

## External Secret Stores

- HashiCorp Vault
- AWS Secrets Manager
- Azure Key Vault
- GCP Secret Manager

Inject secrets at runtime via a sidecar or an init container, or fetch them in the application startup.

## Handling Secrets in Compose (without Swarm)

```yaml
services:
  app:
    image: myapp
    environment:
      - DB_PASSWORD_FILE=/run/secrets/db_password
    volumes:
      - ./db_password.txt:/run/secrets/db_password:ro
```

Still risky; the file is on the host. For production, prefer Swarm secrets or external vaults.

## Key Principles

- Secrets should never be in plaintext in image layers.
- Secrets should be provisioned at runtime.
- Limit access: only the containers that need a secret should have it.
- Rotate secrets regularly.

> 📘 Next: [Rootless Docker](rootless-docker.md)
