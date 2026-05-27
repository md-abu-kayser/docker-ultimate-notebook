# tmpfs Mounts

A `tmpfs` mount stores data in the host’s memory, not on disk.

## Why tmpfs?

- **Performance**: extremely fast read/write.
- **Security**: data never touches the disk, useful for sensitive temporary data (secrets, tokens).
- **Temporary**: data is lost when container stops.

## Using tmpfs

```bash
docker run -d --tmpfs /app/tmp:rw,size=100M nginx
```

With `--mount`:

```bash
docker run --mount type=tmpfs,destination=/app/tmp,tmpfs-size=100M nginx
```

## Options

- `size`: maximum bytes (e.g., `100m`).
- `mode`: file mode (octal, e.g., `1777`).
- `uid` / `gid`: ownership (not always supported).

## Limitations

- Cannot be shared between containers.
- Limited by host memory; using too much can cause OOM.
- Not persistent.

## Use Cases

- Application caches.
- Temporary file processing (e.g., image manipulation).
- Storing secrets that should never be persisted.

## tmpfs in Docker Compose

```yaml
services:
  app:
    image: myapp
    tmpfs:
      - /tmp
      - /run:size=64m,noexec
```

> 🔗 Next: [Storage Drivers](storage-drivers.md)
