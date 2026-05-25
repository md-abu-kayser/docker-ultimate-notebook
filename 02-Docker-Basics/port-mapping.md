# Port Mapping – Exposing Containers to the Outside World

Containers live in isolated networks by default. To make services accessible from the host or the internet, you must publish ports.

## How Port Mapping Works

Docker can map a host port to a container port.

```
Host:8080  <------->  Container:80
```

The container listens on a specific port. Docker’s networking stack intercepts traffic on the host port and forwards it to the container’s port.

## Publishing Ports at Runtime

```bash
docker run -p [host_port]:[container_port] [image]
```

Examples:

```bash
docker run -d -p 8080:80 nginx:alpine       # host 8080 → container 80
docker run -d -p 3000:3000 my-web-app
```

## Binding to a Specific Host Interface

By default, the host port binds to `0.0.0.0` (all interfaces). You can restrict it:

```bash
docker run -p 127.0.0.1:8080:80 nginx:alpine   # only localhost
```

Or bind to a particular IP:

```bash
docker run -p 192.168.1.100:8080:80 nginx:alpine
```

## Publishing Multiple Ports

```bash
docker run -d \
  -p 80:80 \
  -p 443:443 \
  -p 3306:3306 \
  wordpress
```

## Random Host Port (Dynamic)

Let Docker pick an available host port:

```bash
docker run -d -P myimage    # publish all exposed ports to random host ports
```

Find the assigned port:

```bash
docker port <container>
```

## Exposing vs Publishing

- `EXPOSE 80` in a Dockerfile is **documentation** – it does not publish the port.
- `-p` or `-P` at runtime **actually publishes** the port.

## Example: Two Containers with Port Mappings

```bash
docker run -d --name web1 -p 8081:80 nginx:alpine
docker run -d --name web2 -p 8082:80 httpd:alpine
```

Now `http://localhost:8081` hits Nginx, `http://localhost:8082` hits Apache.

## Inspect Port Mappings

```bash
docker inspect --format='{{json .NetworkSettings.Ports}}' web1
```

Output: `{"80/tcp":[{"HostIp":"0.0.0.0","HostPort":"8081"}]}`

## Troubleshooting

- Ensure no firewall blocks the host port.
- Check if another process already uses the port: `lsof -i :8080` (Linux/macOS).
- Inside the container, verify the service listens on `0.0.0.0` (not just `127.0.0.1`).

## Port Mapping in Docker Compose

```yaml
services:
  web:
    image: nginx:alpine
    ports:
      - "8080:80"
```

> 📘 Next: [Environment Variables](environment-variables.md)
