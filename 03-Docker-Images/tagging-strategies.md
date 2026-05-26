# Image Tagging Strategies

Consistent tagging is essential for traceability, rollback, and deployment safety.

## Common Tagging Approaches

### 1. Semantic Versioning (SemVer)

```
myapp:1.0.0
myapp:1.0
myapp:1
```

- Push all three tags for the same image.
- Consumers can pin to a specific patch or minor version.
- `latest` is not used.

### 2. Git Commit Hash

```
myapp:git-a1b2c3d
myapp:git-a1b2c3d-20240301
```

- Immutable and traceable to source code.
- Often combined with a branch name (e.g., `myapp:develop-a1b2c3d`).

### 3. Environment‑Based Tags

```
myapp:staging
myapp:production
```

- Simple but risky – `staging` is mutable.
- Better to use immutable tags and promote them.

### 4. Date/Time Stamps

```
myapp:2024-03-15-1420
```

- Useful for automatic builds, but hard to order.

### 5. Hybrid Strategy (Recommended)

```
myapp:1.2.3
myapp:1.2
myapp:1
myapp:git-abc1234
myapp:latest   # only for local/dev use, never in production
```

## The `:latest` Trap

`latest` is the default tag when none is specified. It’s **not** the most recent pushed image; it’s just the last image built/pulled without an explicit tag. Never rely on `latest` in production.

## Pushing Tags Correctly

```bash
docker build -t myapp:1.2.3 -t myapp:1.2 -t myapp:git-$(git rev-parse --short HEAD) .
docker push myapp:1.2.3
docker push myapp:1.2
docker push myapp:git-...
```

## Promoting Images Between Environments

Instead of rebuilding, simply retag:

```bash
docker pull myapp:staging
docker tag myapp:staging myapp:production
docker push myapp:production
```

## Registry Best Practices

- Cleanup old, unused tags to save storage.
- Use a private registry with retention policies.
- Sign images (Docker Content Trust) for integrity.

> 🔗 Next: [Layers and Caching](layers-and-caching.md)
