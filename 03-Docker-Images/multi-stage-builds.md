# Multi‑Stage Builds

Multi‑stage builds allow you to produce minimal final images by separating the build environment from the runtime environment.

## Why Multi‑Stage?

- Reduce image size (no compilers, build tools, or intermediate artifacts).
- Improve security (smaller attack surface).
- Simplify pipelines (no extra scripts to extract artifacts).

## Syntax

```dockerfile
FROM golang:1.21 AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o myapp .

FROM alpine:3.18
RUN apk add --no-cache ca-certificates
COPY --from=builder /app/myapp /usr/local/bin/
ENTRYPOINT ["myapp"]
```

- `AS` names the stage.
- `COPY --from=<stage>` copies artifacts from a previous stage.

## Multiple Stages

You can have more than two stages:

```dockerfile
FROM node:18 AS deps
...
FROM node:18 AS build
COPY --from=deps /app/node_modules ./node_modules
...
FROM nginx:alpine AS production
COPY --from=build /app/dist /usr/share/nginx/html
```

## Using an External Image as a Stage

```dockerfile
COPY --from=nginx:alpine /etc/nginx/nginx.conf /custom/nginx.conf
```

## Building Specific Stages

Build only up to a certain stage:

```bash
docker build --target builder -t myapp-builder .
```

Useful for debugging or extracting build artifacts.

## Tips

- Start with the most stable layer first (dependency installation).
- Use smaller base images for the final stage (alpine, distroless, scratch).
- Keep the build stage lean; only copy what’s needed.

## Real‑World Example: Node.js Frontend

```dockerfile
# Build stage
FROM node:18-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Production stage
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

> 📘 Next: **04‑Docker‑Compose** – starting with [Compose Basics](../04-Docker-Compose/compose-basics.md)
