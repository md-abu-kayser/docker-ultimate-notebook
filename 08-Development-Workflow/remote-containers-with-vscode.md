# Remote Development with VS Code Dev Containers

Visual Studio Code’s **Dev Containers** extension lets you use a Docker container as a full‑featured development environment.

## How It Works

- You define a dev container configuration (`.devcontainer/devcontainer.json`).
- VS Code builds and runs the container, then mounts your code and attaches.
- You get full IntelliSense, debugging, and extensions running inside the container.

## Prerequisites

- Docker installed.
- VS Code with **Dev Containers** extension (`ms-vscode-remote.remote-containers`).

## Basic Setup

Create `.devcontainer/devcontainer.json` in your project root:

```json
{
  "name": "My App Dev Container",
  "image": "mcr.microsoft.com/devcontainers/typescript-node:18",
  "forwardPorts": [3000],
  "postCreateCommand": "npm install",
  "customizations": {
    "vscode": {
      "extensions": ["dbaeumer.vscode-eslint", "esbenp.prettier-vscode"]
    }
  }
}
```

## Using Docker Compose in Dev Containers

```json
{
  "name": "Full Stack App",
  "dockerComposeFile": "../docker-compose.yml",
  "service": "frontend",
  "workspaceFolder": "/app",
  "shutdownAction": "stopCompose"
}
```

## Features

- Automatically forwards ports.
- Mounts source code into the container.
- Installs specified VS Code extensions inside the container.
- Runs a `postCreateCommand` to set up the environment.

## Opening a Project in a Dev Container

- Open the command palette (`Ctrl+Shift+P`) → **Dev Containers: Reopen in Container**.
- VS Code will rebuild and attach.

## Custom Dockerfile

```json
{
  "build": {
    "dockerfile": "Dockerfile.dev"
  },
  "remoteUser": "node"
}
```

## Advanced: Multiple Containers

You can define a multi‑service environment using Compose, and open each service in a separate VS Code window or use a single main service.

## Tips

- Use a `postStartCommand` for background tasks.
- Store the `.devcontainer` folder in Git to share with the team.
- Limit resource usage: set memory/CPU limits in the Docker Compose or `runArgs`.

## Troubleshooting

- **Rebuild without cache**: Command palette → **Dev Containers: Rebuild Without Cache**.
- **Check logs**: View the `Dev Containers` output panel.

> 🔗 Next: [Testing Strategies](testing-strategies.md)
