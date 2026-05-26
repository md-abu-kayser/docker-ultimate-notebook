# Build Context & .dockerignore

## What Is the Build Context?

The **build context** is the set of files (and directories) at the specified path (usually `.`) that Docker can access during the build. Docker sends the entire context to the daemon before executing any instruction.

## Why Context Size Matters

- Large context (node_modules, .git, logs) slows down builds.
- You can accidentally include sensitive files.

## .dockerignore File

Create a `.dockerignore` file in the context root to exclude files.

### Example `.dockerignore`

```
.git
node_modules
*.log
.env
Dockerfile
docker-compose.yml
*.md
!README.md    # exception: include README.md
```

Syntax is similar to `.gitignore`.

## Best Practices

- Start with a small base directory (dedicated `build/` folder if needed).
- Use `.dockerignore` to trim the context.
- Run `docker build` from the project root only with proper ignores.

## Checking Context Size

Before building, you can list what gets sent:

```bash
tar -czh . | docker build -f - .   # not directly, but you can dry-run with
tar -czh . | wc -c
```

Or use `docker build` with `--progress=plain` to see context size.

## Building with a Remote Context

You can use a Git repository as context:

```bash
docker build https://github.com/user/repo.git#branch:subfolder
```

## Dockerfile Location

By default, Dockerfile must be named `Dockerfile` and be in the context root. Use `-f` to specify an alternative:

```bash
docker build -f docker/Dockerfile.prod -t myapp .
```

> 🔗 Next: [Tagging Strategies](tagging-strategies.md)
