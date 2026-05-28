# Production‑Ready Dockerfile

A production Dockerfile differs from a development one. It prioritizes security, size, and reproducibility.

## 1. Start from a Minimal Base

```dockerfile
FROM node:18-alpine AS build
...
FROM alpine:3.18
```

Prefer `alpine`, `distroless`, or `scratch`. The final image should have no build tools.

## 2. Multi‑Stage Builds

Separate build and runtime stages:

```dockerfile
FROM golang:1.21 AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -o myapp

FROM scratch
COPY --from=builder /app/myapp /myapp
ENTRYPOINT ["/myapp"]
```

## 3. Run as Non‑Root

```dockerfile
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser
```

## 4. Use `.dockerignore`

Exclude unnecessary files to keep the build context small and avoid leaking secrets.

## 5. Pin Exact Versions

```dockerfile
FROM python:3.11.4-slim@sha256:abc...
```

Or use specific tags, never `:latest` in production.

## 6. Set a Health Check

```dockerfile
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost/health || exit 1
```

## 7. Use `exec` Form for CMD/ENTRYPOINT

```dockerfile
CMD ["nginx", "-g", "daemon off;"]
```

Ensures signals are forwarded correctly.

## 8. Drop Capabilities at Runtime

Even if not in Dockerfile, document recommended runtime flags:

```bash
docker run --cap-drop=ALL --read-only myapp
```

## 9. Avoid Leaking Secrets

Use BuildKit secrets for any secret needed during build. Never use `ENV` for sensitive data.

## 10. Clean Up Temporary Files

```dockerfile
RUN apt-get update && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/*
```

## 11. Set Resource Limits

Document expected CPU and memory usage; set limits at deployment.

## 12. Use a Known Base Image

Prefer official images or verified publisher images.

## Example Production Node.js Dockerfile

```dockerfile
# Build stage
FROM node:18-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .

# Production stage
FROM node:18-alpine
RUN addgroup -S app && adduser -S app -G app
WORKDIR /app
COPY --chown=app:app --from=build /app .
USER app
EXPOSE 3000
HEALTHCHECK CMD wget -qO- http://localhost:3000/health || exit 1
CMD ["node", "server.js"]
```

> 📘 Next: [Image Tagging Strategy](image-tagging-strategy.md)
