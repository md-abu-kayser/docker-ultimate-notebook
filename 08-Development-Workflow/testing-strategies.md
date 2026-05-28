# Testing Strategies with Docker

Docker allows you to run tests in an environment identical to production, improving reliability.

## 1. Unit Tests in Build Stage

Use multi‑stage builds to run unit tests and fail the build if they don’t pass.

```dockerfile
FROM node:18 AS test
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm test

FROM node:18-alpine AS production
COPY --from=test /app/dist ./dist
...
```

Build with `docker build --target test` and check exit code.

## 2. Testing with Docker Compose

Define a test service that depends on the application.

```yaml
services:
  app:
    build: .
    ports:
      - "3000:3000"
  test:
    build:
      context: .
      target: test
    depends_on:
      - app
    environment:
      - API_URL=http://app:3000
    command: npm run integration-test
```

Run: `docker compose up --abort-on-container-exit --exit-code-from test`

## 3. Integration Tests with Real Services

Spin up databases, message queues, etc., using Compose.

```yaml
services:
  db-test:
    image: postgres:15-alpine
    environment:
      POSTGRES_PASSWORD: test
  app:
    build: .
    depends_on:
      - db-test
    environment:
      - DB_HOST=db-test
  tests:
    build:
      target: test
    depends_on:
      - app
```

## 4. End‑to‑End Tests

Add a Selenium or Playwright container:

```yaml
services:
  e2e:
    image: mcr.microsoft.com/playwright:latest
    depends_on:
      - app
    command: npx playwright test
    volumes:
      - ./e2e:/e2e
    working_dir: /e2e
    environment:
      - BASE_URL=http://app:3000
```

## 5. Testing in CI/CD

Run the same Compose file in your pipeline. Use `docker compose up --exit-code-from test` to propagate test exit codes.

## 6. Temporary Databases

Always use ephemeral databases for tests (no volumes) or mount a fresh data directory.

## 7. Code Coverage

Generate coverage reports inside the test container and copy them out:

```dockerfile
RUN npm run test:coverage
```

Then in CI, use `docker cp` or a volume to extract the report.

## Best Practices

- Keep test images close to production images.
- Use `.dockerignore` to exclude test artifacts from build context.
- Run unit tests during image build, integration/E2E after deployment.
- Use healthchecks to wait for service readiness.

> 🎉 Congratulations! You’ve completed the **Development Workflow** section.

> 📘 Ready to dive in? Head over to **09‑CICD‑with‑Docker** starting with [Building Images in CI](../09-CICD-with-Docker/building-images-in-ci.md)
