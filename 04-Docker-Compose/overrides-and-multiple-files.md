# Override & Multiple Compose Files

Docker Compose supports merging multiple YAML files, enabling environment‑specific configurations.

## Default Merge Behaviour

By default, `docker compose up` reads `docker-compose.yml` and, if present, `docker-compose.override.yml`. The override file is merged with the base.

## Explicit File Order

```bash
docker compose -f docker-compose.yml -f docker-compose.prod.yml up
```

Later files override earlier ones for duplicate keys.

## Example: Base + Production Override

**docker-compose.yml:**

```yaml
services:
  app:
    image: myapp:latest
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=development
```

**docker-compose.prod.yml:**

```yaml
services:
  app:
    ports:
      - "80:3000"
    environment:
      - NODE_ENV=production
    restart: always
```

Run: `docker compose -f docker-compose.yml -f docker-compose.prod.yml up`

## Using `extends` (legacy, v2 only)

In version 2, you could use `extends` to share configuration. In v3, prefer multiple files.

## Override Specific Keys

- Lists are replaced, not merged (e.g., `ports`).
- Dictionaries are merged at the top level.
- Use `!override` syntax? Not needed; just redefine in override.

## Targeted Overrides with Profiles

You can combine multiple files and profiles to enable optional services.

## Tips

- Keep base file simple.
- Put environment‑specific overrides in separate files (`docker-compose.dev.yml`, `docker-compose.prod.yml`).
- Use `.env` for variables that differ across environments, but keep the compose files consistent.

> 🔗 Next: [Compose in Production](compose-in-production.md)
