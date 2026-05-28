# Building Docker Images in CI/CD

Automating image builds in CI ensures consistency and enables automated testing, scanning, and deployment.

## General Principles

- Build once, deploy many: promote the same image through environments.
- Use immutable tags (digest or version) in deployment.
- Leverage layer caching to speed up builds.

## CI Pipeline Steps (Generic)

1. Checkout code.
2. Set up Docker BuildKit (`DOCKER_BUILDKIT=1`).
3. Login to container registry.
4. Build image with metadata tags.
5. Run vulnerability scan.
6. Push image to registry.
7. Deploy / update service.

## Caching in CI

### Docker Layer Caching

Use CI‑provided Docker layer caching:

- GitHub Actions: `docker/build-push-action` with `cache-from` and `cache-to`.
- GitLab CI: `docker build --cache-from`.
- Jenkins: mount a persistent volume.

### Registry Cache

```bash
docker build \
  --cache-from myregistry/myapp:latest \
  -t myregistry/myapp:$CI_COMMIT_SHA \
  .
```

## Tagging Images in CI

```bash
export IMAGE_TAG=$CI_REGISTRY_IMAGE:$CI_COMMIT_SHORT_SHA
docker build -t $IMAGE_TAG .
# Also tag with branch or semver if applicable
docker tag $IMAGE_TAG $CI_REGISTRY_IMAGE:latest
docker push $IMAGE_TAG
docker push $CI_REGISTRY_IMAGE:latest
```

## Scanning in CI

```bash
trivy image --exit-code 1 --severity CRITICAL $IMAGE_TAG
```

## Signing Images

```bash
export DOCKER_CONTENT_TRUST=1
docker trust sign $IMAGE_TAG
```

Or use Cosign:

```bash
cosign sign --key cosign.key $IMAGE_TAG
```

## Multi‑Architecture Builds in CI

Use `docker buildx`:

```bash
docker buildx create --use
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t myapp:$TAG \
  --push .
```

## Environment Variables and Secrets

- Store registry credentials as CI secrets (never hardcode).
- Use CI variables for image names, tags.

## Speeding Up Builds

- Use `.dockerignore`.
- Order Dockerfile for optimal caching.
- Use BuildKit’s parallel builds.
- Use CI‑specific cache mechanisms (GitLab Cache, GitHub Actions cache).

> 🔗 Next: [GitHub Actions Pipeline](github-actions-pipeline.md)
