# Volumes and Networks in Docker Compose

## Defining Volumes

Volumes persist data beyond the lifecycle of a container.

### Named Volume

```yaml
services:
  db:
    image: postgres
    volumes:
      - db_data:/var/lib/postgresql/data

volumes:
  db_data: # declared at top level
```

### Bind Mount (for development)

```yaml
services:
  web:
    image: nginx
    volumes:
      - ./html:/usr/share/nginx/html # host:container
```

### Volume Drivers

```yaml
volumes:
  db_data:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: /mnt/data
```

## Networks

Compose creates a default network for your app (project name + `_default`). Services can reach each other by service name.

### Custom Networks

```yaml
networks:
  frontend:
  backend:

services:
  proxy:
    image: nginx
    networks:
      - frontend
  api:
    image: my-api
    networks:
      - frontend
      - backend
  db:
    image: postgres
    networks:
      - backend
```

- Services on the same network can communicate.
- Use multiple networks to isolate tiers.

### Using External Networks

```yaml
networks:
  my-shared-net:
    external: true
```

Allows containers to join pre‑existing networks (e.g., created by another Compose file or Docker command).

### Network Configuration Options

```yaml
networks:
  custom-net:
    driver: bridge
    driver_opts:
      com.docker.network.bridge.name: br-custom
    ipam:
      config:
        - subnet: 10.5.0.0/24
```

## Linking Containers (legacy)

`links` is deprecated; use user‑defined networks and service name resolution.

> 🔗 Next: [Environment Configuration](environment-configuration.md)
