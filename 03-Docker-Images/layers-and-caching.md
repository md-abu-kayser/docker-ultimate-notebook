# Layers and Caching

Docker builds images in layers. Properly ordering instructions can drastically reduce build times.

## How Layers Work

Each `RUN`, `COPY`, `ADD` instruction creates a new layer. The final image is a stack of read-only layers plus a writable container layer at runtime.

## Layer Caching

Docker caches layers and reuses them if nothing changed. Cache invalidation happens when:

- An instruction itself changes.
- Preceding layers change (because layer order is fixed).

## Optimizing for Cache

**Order instructions from least to most frequently changing**:

Bad:

```dockerfile
COPY . /app
RUN pip install -r requirements.txt
```

Any code change invalidates the cache, forcing `pip install` to re-run.

Good:

```dockerfile
COPY requirements.txt /app/
RUN pip install -r /app/requirements.txt
COPY . /app
```

Now `pip install` only re-runs when `requirements.txt` changes.

## RUN Flattening

Combine multiple commands into one `RUN` to reduce layers and keep the cache line shorter:

```dockerfile
RUN apt-get update && \
    apt-get install -y curl git && \
    rm -rf /var/lib/apt/lists/*
```

## Cache Busting

If you need to force a rebuild, use `--no-cache`:

```bash
docker build --no-cache -t myapp .
```

Or use a build arg:

```dockerfile
ARG CACHE_BUST=1
RUN git clone ...
```

And build with `--build-arg CACHE_BUST=$(date +%s)`.

## COPY vs ADD

- `COPY` is simpler and should be your default.
- `ADD` has extra features (URL fetch, tar extraction) but can surprise you with cache behavior.

## Multi‑Stage and Caching

Multi‑stage builds can cache intermediate stages. Docker automatically reuses cached layers from earlier builds if the stage hasn’t changed.

## Debugging Cache Misses

Use `docker build --progress=plain` to see which layer caused a miss.
Inspect layer digests with `docker history`.

> 🔗 Next: [Multi‑Stage Builds](multi-stage-builds.md)
