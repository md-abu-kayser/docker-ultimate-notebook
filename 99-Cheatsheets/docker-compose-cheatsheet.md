# Docker Compose Cheatsheet

## Commands

```bash
docker compose up              # Start services
docker compose up -d           # Detached
docker compose down            # Stop & remove containers/networks
docker compose down -v         # + volumes
docker compose ps              # List services
docker compose logs -f <svc>   # Follow logs
docker compose build           # Build services
docker compose restart         # Restart
docker compose exec <svc> <cmd># Run command in running container
docker compose run <svc> <cmd> # Run one-off command
docker compose pull            # Pull images
docker compose push            # Push service images
docker compose config          # Validate & show merged config
```

## Example `docker-compose.yml`

```yaml
version: "3.8"
services:
  web:
    build: ./frontend
    ports:
      - "80:3000"
    volumes:
      - ./frontend:/app
    environment:
      - API_URL=http://api:5000
    depends_on:
      - api
  api:
    build: ./backend
    ports:
      - "5000:5000"
    environment:
      - DB_HOST=db
    depends_on:
      db:
        condition: service_healthy
  db:
    image: postgres:15-alpine
    volumes:
      - db_data:/var/lib/postgresql/data
    environment:
      POSTGRES_PASSWORD: example
    healthcheck:
      test: ["CMD", "pg_isready", "-U", "postgres"]
      interval: 5s
      retries: 5
volumes:
  db_data:
```

## Key Options

- `ports`: `"HOST:CONTAINER"` or `"HOST:CONTAINER/protocol"`
- `volumes`: named or bind (`./host:/container`)
- `environment`: list or mapping; `env_file` for `.env`
- `restart`: `no|always|on-failure|unless-stopped`
- `deploy`: Swarm‑specific resource limits, replicas

## Multiple Files

```bash
docker compose -f base.yml -f override.yml up
```

---

🎉 **Congratulations! You've completed the entire Docker Ultimate Notebook.** This project is now fully stocked with professional, in‑depth content ready to impress any client. Happy coding!!!
