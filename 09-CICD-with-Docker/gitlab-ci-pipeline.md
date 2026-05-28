# Docker CI/CD with GitLab CI

GitLab CI has built‑in Docker integration via the Docker executor or Kubernetes.

## Using the Docker Executor

In `.gitlab-ci.yml`:

```yaml
default:
  image: docker:latest
  services:
    - docker:dind

variables:
  DOCKER_DRIVER: overlay2
  DOCKER_TLS_CERTDIR: "/certs"

before_script:
  - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY

stages:
  - build
  - test
  - deploy

build:
  stage: build
  script:
    - docker build -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHORT_SHA .
    - docker push $CI_REGISTRY_IMAGE:$CI_COMMIT_SHORT_SHA
  only:
    - main
```

## Caching with `docker build`

```yaml
build:
  script:
    - docker pull $CI_REGISTRY_IMAGE:latest || true
    - docker build --cache-from $CI_REGISTRY_IMAGE:latest -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHORT_SHA .
    - docker push $CI_REGISTRY_IMAGE:$CI_COMMIT_SHORT_SHA
    - docker tag $CI_REGISTRY_IMAGE:$CI_COMMIT_SHORT_SHA $CI_REGISTRY_IMAGE:latest
    - docker push $CI_REGISTRY_IMAGE:latest
```

## Using BuildKit and Layer Caching

```yaml
variables:
  DOCKER_BUILDKIT: 1
build:
  script:
    - |
      docker build \
        --cache-from $CI_REGISTRY_IMAGE:cache \
        --build-arg BUILDKIT_INLINE_CACHE=1 \
        -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHORT_SHA \
        -t $CI_REGISTRY_IMAGE:cache \
        .
    - docker push $CI_REGISTRY_IMAGE:$CI_COMMIT_SHORT_SHA
    - docker push $CI_REGISTRY_IMAGE:cache
```

## Scanning with Trivy

```yaml
security-scan:
  stage: test
  image: docker:latest
  services:
    - docker:dind
  script:
    - docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image --severity CRITICAL --exit-code 1 $CI_REGISTRY_IMAGE:$CI_COMMIT_SHORT_SHA
```

## Deploy Stage

```yaml
deploy:
  stage: deploy
  image: docker:latest
  services:
    - docker:dind
  script:
    - docker pull $CI_REGISTRY_IMAGE:$CI_COMMIT_SHORT_SHA
    - docker tag $CI_REGISTRY_IMAGE:$CI_COMMIT_SHORT_SHA myapp:prod
    - docker stack deploy -c docker-compose.prod.yml myapp
  environment:
    name: production
  only:
    - main
```

## Using GitLab Container Registry

GitLab provides a built‑in registry per project. Environment variables:

- `$CI_REGISTRY` – registry URL
- `$CI_REGISTRY_IMAGE` – image path
- `$CI_REGISTRY_USER` / `$CI_REGISTRY_PASSWORD` – auto‑generated credentials

## Multi‑Architecture Builds

Use a builder with `docker buildx`:

```yaml
build-multiarch:
  image: docker:latest
  services:
    - docker:dind
  script:
    - docker buildx create --use
    - docker buildx build --platform linux/amd64,linux/arm64 -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHORT_SHA --push .
```

> 🔗 Next: [Jenkins Pipeline](jenkins-pipeline.md)
