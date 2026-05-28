# Hot Reload & Debugging in Docker

To keep a fast development cycle, enable hot reloading and attach debuggers to your containerized apps.

## 1. Node.js Hot Reload

Mount the source code and use a development server (e.g., `nodemon`, `vite`).

```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
CMD ["npm", "run", "dev"]
```

In Compose:

```yaml
services:
  frontend:
    build: ./frontend
    volumes:
      - ./frontend:/app
      - /app/node_modules
    environment:
      - CHOKIDAR_USEPOLLING=true # for macOS/Windows file events
```

## 2. Python Flask/Django Auto‑Reload

Flask’s built‑in debug mode reloads on file changes:

```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
CMD ["flask", "run", "--host=0.0.0.0", "--debug"]
```

Mount code:

```yaml
volumes:
  - ./backend:/app
environment:
  - FLASK_DEBUG=1
```

## 3. Hot Reload with Vite/Rollup (Frontend Bundlers)

Ensure the dev server watches for changes. For Vite:

```yaml
command: npx vite --host 0.0.0.0
```

## Debugging Containers

### Node.js Debugger

Expose debug port and attach:

```yaml
ports:
  - "9229:9229"
command: node --inspect=0.0.0.0:9229 server.js
```

Then in Chrome DevTools or VS Code, attach to `localhost:9229`.

### Python Debugging with `debugpy`

Add `debugpy` and start app with:

```yaml
command: python -m debugpy --listen 0.0.0.0:5678 --wait-for-client app.py
```

Attach VS Code’s Python debugger.

### General Debugging

- `docker exec -it <container> sh` to explore the filesystem.
- Use `docker logs -f` for real‑time output.
- Set `STDOUT` / `STDERR` to see logs in the console.

## Environment Variables for Debugging

- `NODE_ENV=development`
- `DEBUG=express:*`
- `LOG_LEVEL=debug`

## Mounting Debug Configurations

Mount your IDE’s debug config into the container for seamless debugging.

## VS Code Integration

Use the Remote‑Containers extension (next file) or a launch configuration with `"type": "node"` or `"python"` pointing to the container port.

## Performance Considerations

- Volume mounts (especially on macOS) can be slow. Use `cached` or `delegated` mount options:
  ```yaml
  volumes:
    - ./frontend:/app:delegated
  ```
- Consider using `docker-sync` or `mutagen` for large codebases.

> 🔗 Next: [Remote Containers with VS Code](remote-containers-with-vscode.md)
