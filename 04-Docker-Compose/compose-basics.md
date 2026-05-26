# Docker Compose Basics

Docker Compose defines and runs multi‑container applications with a single YAML file.

## What It Solves

Instead of long `docker run` commands with multiple flags, you describe your entire stack in `docker-compose.yml` and manage it with simple commands.

## A Simple `docker-compose.yml`

```yaml
version: "3.8"

services:
  web:
    image: nginx:alpine
    ports:
      - "8080:80"
  api:
    build: ./api
    ports:
      - "3000:3000"
    environment:
      - DATABASE_URL=postgres://user:pass@db:5432/mydb
    depends_on:
      - db
  db:
    image: postgres:15-alpine
    volumes:
      - postgres_data:/var/lib/postgresql/data
    environment:
      POSTGRES_PASSWORD: example

volumes:
  postgres_data:
```

## Key Concepts

- **services**: containers that make up your app.
- **networks**: automatically created; services can communicate by service name.
- **volumes**: persistent storage managed by Compose.

## Basic Commands

```bash
docker compose up               # start all services in foreground
docker compose up -d            # detached mode
docker compose down             # stop and remove containers, networks
docker compose down -v          # also remove volumes
docker compose ps               # list services
docker compose logs -f          # follow logs
docker compose build            # build or rebuild services
docker compose restart          # restart all services
```

## Building vs Pulling

- `image:` pulls a ready image.
- `build:` builds from a Dockerfile.
- Both can be used together: `build: .` with `image: myapp:latest` tags the built image.

## Port Mapping

```yaml
ports:
  - "8080:80" # host:container
  - "443:443"
```

## Environment Variables

```yaml
environment:
  - DEBUG=1
  - DB_HOST=db
# or from a file:
env_file:
  - .env
```

## Profiles (optional services)

```yaml
services:
  debug-tools:
    image: alpine
    profiles: ["debug"]
```

Start with: `docker compose --profile debug up`

> 🔗 Next: [Services, Dependencies, and Healthchecks](services-dependencies-and-healthchecks.md)
