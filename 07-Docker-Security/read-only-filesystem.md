# Read‑Only Root Filesystem

Making the container’s root filesystem read‑only prevents an attacker from modifying binaries or writing malware.

## Using `--read-only`

```bash
docker run --read-only nginx:alpine
```

This makes the root filesystem and all image layers read‑only. The container will fail if the application tries to write anywhere.

## Mounting Writable Directories

Most applications need to write to temporary or data directories. Mount them as `tmpfs` or volumes:

```bash
docker run --read-only \
  --tmpfs /tmp \
  --tmpfs /var/run \
  -v app_data:/var/lib/nginx \
  nginx:alpine
```

Common writable paths:

- `/tmp`
- `/var/run`
- `/var/tmp`
- Application‑specific (logs, caches)

## In Docker Compose

```yaml
services:
  app:
    image: myapp
    read_only: true
    tmpfs:
      - /tmp
      - /run
    volumes:
      - app_data:/data
```

## In Dockerfile (Partial)

You can’t enforce read‑only at build time, but you can set up writable directories correctly:

```dockerfile
VOLUME /data
# At runtime, mount -v with read‑only root
```

## Verifying

Inside a read‑only container:

```bash
docker exec -it <container> touch /test-file
# touch: cannot touch '/test-file': Read-only file system
```

## Applications That Expect Write Access

Some frameworks need write access to certain paths (e.g., `node_modules/.cache`, Python `__pycache__`). You must mount those as writable volumes/tmpfs.

## Security Benefits

- Prevents tampering with binaries.
- Blocks many rootkit and malware techniques.
- Encourages stateless application design.

## Limitations

- Not a silver bullet; attackers can still write to mounted writable volumes.
- May require additional development effort to redirect writes.

> 📘 Next: [Content Trust & Image Signing](content-trust-and-image-signing.md)
