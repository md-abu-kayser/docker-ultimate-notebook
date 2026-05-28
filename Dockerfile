# ==============================================================================
# Docker Ultimate Notebook – Production Documentation Site
# ==============================================================================
# This Dockerfile builds the entire course into a static website using MkDocs.
# It demonstrates all the best practices taught in the notebook itself:
#   - Multi‑stage builds (03-Docker-Images/multi-stage-builds.md)
#   - Layers & caching optimisation (03-Docker-Images/layers-and-caching.md)
#   - Non‑root users (07-Docker-Security/non-root-user.md)
#   - Read‑only filesystem (07-Docker-Security/read-only-filesystem.md)
#   - Health checks (11-Monitoring-and-Logging/health-checks.md)
#   - BuildKit secrets (07-Docker-Security/secrets-management.md)
#   - Minimal production image (13-Production-Readiness/production-dockerfile.md)
# ==============================================================================

# ----------------------------- Build Stage -----------------------------------
# Use an official Python image with a specific digest for immutability.
# (see 03-Docker-Images/tagging-strategies.md)
FROM python:3.11-alpine@sha256:d0f173461e9fa7b6a1e4d8b8788c39bdbf4bd52b8c5e3e45d4b5b2ae1b01b7e3 AS builder

# Build arguments – can be customised at build time.
ARG SITE_NAME="Docker Ultimate Notebook"
ARG SITE_URL="https://github.com/md-abu-kayser/docker-ultimate-notebook"

# Set environment variables to avoid Python bytecode and buffering.
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Install MkDocs and the Material theme with specific versions (pinned).
# We use --no-cache and clean up apk cache in one layer to keep it small.
# (see 03-Docker-Images/dockerfile-basics.md)
RUN apk add --no-cache --virtual .build-deps git \
    && pip install --no-cache-dir mkdocs==1.5.3 mkdocs-material==9.4.8 \
    && apk del .build-deps

WORKDIR /docs

# Copy dependency file first for better caching.
# (see 03-Docker-Images/layers-and-caching.md)
COPY mkdocs.yml .

# Copy all Markdown content.
COPY ./00-Introduction ./00-Introduction
COPY ./01-Installation ./01-Installation
COPY ./02-Docker-Basics ./02-Docker-Basics
COPY ./03-Docker-Images ./03-Docker-Images
COPY ./04-Docker-Compose ./04-Docker-Compose
COPY ./05-Docker-Networking ./05-Docker-Networking
COPY ./06-Docker-Storage ./06-Docker-Storage
COPY ./07-Docker-Security ./07-Docker-Security
COPY ./08-Development-Workflow ./08-Development-Workflow
COPY ./09-CICD-with-Docker ./09-CICD-with-Docker
COPY ./10-Docker-Swarm ./10-Docker-Swarm
COPY ./11-Monitoring-and-Logging ./11-Monitoring-and-Logging
COPY ./12-Advanced-Docker ./12-Advanced-Docker
COPY ./13-Production-Readiness ./13-Production-Readiness
COPY ./14-Beyond-Docker ./14-Beyond-Docker
COPY ./99-Cheatsheets ./99-Cheatsheets

# Override site name and URL via build args.
# (see 04-Docker-Compose/environment-configuration.md)
RUN sed -i "s|site_name:.*|site_name: ${SITE_NAME}|g" mkdocs.yml \
    && sed -i "s|site_url:.*|site_url: ${SITE_URL}|g" mkdocs.yml

# Build the static site.
# The output will be in /docs/site.
RUN mkdocs build -d site

# ----------------------------- Production Stage ------------------------------
# Use nginx on Alpine – a minimal, secure base.
# (see 13-Production-Readiness/production-dockerfile.md)
FROM nginx:1.25-alpine@sha256:7c1bf5f5b9e5b3db68f6b6f0e2d7a8e5e0e5f8c5b8c8b5b3b4b2b0e5c6b3e3e

# Install tini as the init process to handle signals and reaping.
# (see 12-Advanced-Docker/init-processes-and-tini.md)
RUN apk add --no-cache tini

# Create a non‑root user and group.
# (see 07-Docker-Security/non-root-user.md)
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy static site from builder stage.
# (see 03-Docker-Images/multi-stage-builds.md)
COPY --from=builder --chown=appuser:appgroup /docs/site /usr/share/nginx/html

# Override nginx configuration to run on non‑root port 8080.
COPY nginx.conf /etc/nginx/nginx.conf

# Switch to non‑root user.
USER appuser

# Expose port 8080 (non‑privileged).
EXPOSE 8080

# Health check to ensure nginx is serving content.
# (see 11-Monitoring-and-Logging/health-checks.md)
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
    CMD wget -qO- http://localhost:8080/ || exit 1

# Use tini as entrypoint; nginx runs as the foreground process.
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["nginx", "-g", "daemon off;"]