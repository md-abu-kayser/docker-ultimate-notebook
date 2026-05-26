# Environment Configuration in Compose

Compose offers multiple ways to inject configuration into containers.

## 1. `environment` Key

```yaml
services:
  api:
    environment:
      - DEBUG=1
      - DB_HOST=db
```

Or using a mapping:

```yaml
environment:
  DEBUG: "1"
  DB_HOST: db
```

## 2. `env_file`

Load variables from a file (`.env` by default):

```yaml
services:
  api:
    env_file:
      - ./api.env
```

Contents of `api.env`:

```
DEBUG=true
DATABASE_URL=postgres://...
```

## 3. Variable Substitution

Compose automatically substitutes variables from the shell or a `.env` file in the project directory:

```yaml
services:
  api:
    image: myapp:${TAG:-latest}
    ports:
      - "${HOST_PORT:-3000}:3000"
```

Use `$$` to escape a dollar sign.

## 4. Using `secrets` (Swarm mode only in v3)

In non‑swarm setups, secrets are just bind mounts of a file. For Docker Swarm, use:

```yaml
secrets:
  db_password:
    file: ./db_password.txt

services:
  db:
    secrets:
      - db_password
```

## 5. `configs` (Swarm mode)

Similar to secrets, but for non‑sensitive configuration files.

## Priority / Precedence

1. Shell environment variables (override `.env`).
2. `.env` file in project directory.
3. `environment` in Compose file.
4. `env_file` values.
5. Dockerfile `ENV` defaults.

## Best Practices

- Never commit `.env` files with secrets; use a `.env.example`.
- For production, use secret management tools (HashiCorp Vault, AWS Secrets Manager) and inject via CI/CD.
- Use consistent naming: `SERVICE_VARIABLE` (e.g., `DB_HOST`, `API_PORT`).

> 🔗 Next: [Override & Multiple Compose Files](overrides-and-multiple-files.md)
