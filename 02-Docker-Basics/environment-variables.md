# Environment Variables in Docker

Environment variables allow you to pass configuration to your application without modifying the image. They are essential for building 12‑factor apps.

## Setting Environment Variables at Runtime

### Using the `-e` Flag

```bash
docker run -e APP_ENV=production -e LOG_LEVEL=debug myapp
```

### Using a File (`--env-file`)

Create a `.env` file:

```
APP_ENV=production
LOG_LEVEL=debug
DATABASE_URL=postgres://user:pass@host/db
```

Then run:

```bash
docker run --env-file ./.env myapp
```

## Inspecting Environment Variables Inside a Container

```bash
docker exec <container> env
```

Or inspect the container metadata:

```bash
docker inspect <container> --format '{{json .Config.Env}}' | jq
```

## Setting Environment Variables in Dockerfile

```dockerfile
FROM node:18-alpine
ENV NODE_ENV=production
ENV APP_PORT=3000
```

- `ENV` sets a default value; can be overridden at runtime with `-e`.
- Multiple variables can be set in one line:
  ```dockerfile
  ENV NODE_ENV=production \
      APP_PORT=3000
  ```

## Precedence

Runtime (`-e`) > Dockerfile (`ENV`) > Image default. Environment variables from `--env-file` are merged with `-e`; latter overrides.

## Security Consideration

Never hardcode secrets like API keys in a Dockerfile. Use runtime environment variables or, better, Docker secrets (Swarm) / external secret stores.

## Example: A Python App with Env Vars

Dockerfile:

```dockerfile
FROM python:3.11-slim
ENV FLASK_DEBUG=0
COPY . /app
WORKDIR /app
RUN pip install -r requirements.txt
CMD ["python", "app.py"]
```

Run:

```bash
docker run -e FLASK_DEBUG=1 -e DATABASE_URL=sqlite:///data.db my-python-app
```

## List All Environment Variables of a Container

```bash
docker inspect mycontainer | jq '.[0].Config.Env'
```

## Default Values in Application Code

It’s a good practice to provide defaults in the application itself (e.g., `os.getenv("PORT", "3000")`). This makes the container usable without explicit env vars.

## Using Environment Variables in Docker Compose

```yaml
services:
  api:
    image: myapp
    environment:
      - APP_ENV=staging
      - DB_HOST=postgres
    env_file:
      - ./config.env
```

> 🎉 Congratulations! You’ve completed the **Docker Basics** section.

Next, move into **03-Docker-Images**, where you’ll learn how to build efficient, optimized, and secure Docker images.

📘 Start here: [Docker Architecture](../02-Docker-Basics/architecture.md)
