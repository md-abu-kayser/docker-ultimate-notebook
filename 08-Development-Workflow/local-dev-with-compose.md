# Local Development with Docker Compose

Docker Compose streamlines local development by defining your entire stack in one file and offering hot‑reload capabilities.

## Project Structure

```
myapp/
├── docker-compose.yml
├── .env
├── frontend/
│   ├── Dockerfile
│   ├── package.json
│   └── src/
├── backend/
│   ├── Dockerfile
│   └── app.py
└── nginx/
    └── default.conf
```

## Example `docker-compose.yml`

```yaml
services:
  frontend:
    build: ./frontend
    ports:
      - "3000:3000"
    volumes:
      - ./frontend:/app
      - /app/node_modules # anonymous volume to preserve dependencies
    environment:
      - NODE_ENV=development
    command: npm run dev

  backend:
    build: ./backend
    ports:
      - "5000:5000"
    volumes:
      - ./backend:/app
    environment:
      - FLASK_ENV=development
    depends_on:
      - db

  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_PASSWORD: devpass
    volumes:
      - db_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  nginx:
    image: nginx:alpine
    volumes:
      - ./nginx/default.conf:/etc/nginx/conf.d/default.conf
    ports:
      - "80:80"
    depends_on:
      - frontend
      - backend

volumes:
  db_data:
```

## Benefits for Development

- **Reproducible environment** – all developers use the same dependencies.
- **Isolation** – no need to install Node.js, Python, or PostgreSQL locally.
- **Service discovery** – containers communicate by service name.
- **Volume mounts** – live code syncing.

## Starting the Stack

```bash
docker compose up -d
docker compose logs -f
docker compose down
```

## Database Development

- Map the database port to the host so you can connect with local tools (DBeaver, pgAdmin).
- Use a startup script to seed data:
  ```yaml
  db:
    volumes:
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql
  ```

## Using `.env` File

```
POSTGRES_PASSWORD=devpass
NODE_ENV=development
```

Variables are substituted automatically.

## Overriding for Development

Create a `docker-compose.override.yml` to add dev‑specific settings (volumes, debug commands). Compose merges it automatically.

```yaml
services:
  backend:
    command: flask run --debug
    ports:
      - "5678:5678" # debugger port
```

> 🔗 Next: [Hot Reload & Debugging](hot-reload-and-debugging.md)
