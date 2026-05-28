# Dockerfile Instructions Quick Reference

| Instruction | Syntax                                          | Purpose                                    |
| ----------- | ----------------------------------------------- | ------------------------------------------ |
| FROM        | `FROM <image>[:<tag>] [AS <stage>]`             | Base image                                 |
| RUN         | `RUN <command>` (shell) / `RUN ["exec"]` (exec) | Execute commands during build              |
| CMD         | `CMD ["exec","p1"]` / `CMD command`             | Default command when container runs        |
| LABEL       | `LABEL key=value`                               | Metadata                                   |
| EXPOSE      | `EXPOSE <port>`                                 | Document port                              |
| ENV         | `ENV KEY=value`                                 | Environment variables                      |
| ADD         | `ADD src dst`                                   | Copy from context or URL, tar auto‑extract |
| COPY        | `COPY [--chown=user:group] src dst`             | Copy from context                          |
| ENTRYPOINT  | `ENTRYPOINT ["exec"]`                           | Configure executable container             |
| VOLUME      | `VOLUME ["/data"]`                              | Create mount point                         |
| USER        | `USER <user>[:<group>]`                         | Set user for subsequent instructions       |
| WORKDIR     | `WORKDIR /path`                                 | Set working directory                      |
| ARG         | `ARG <name>[=default]`                          | Build‑time variable                        |
| ONBUILD     | `ONBUILD <instruction>`                         | Trigger when image is used as base         |
| STOPSIGNAL  | `STOPSIGNAL signal`                             | Set stop signal                            |
| HEALTHCHECK | `HEALTHCHECK [options] CMD <command>`           | Container health check                     |
| SHELL       | `SHELL ["executable", "params"]`                | Override default shell                     |

## Example

```dockerfile
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
HEALTHCHECK CMD wget -qO- localhost || exit 1
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

> 📘 Next: [Docker Compose Cheatsheet](docker-compose-cheatsheet.md)
