# Dockerfile Instructions Reference

Complete reference of all Dockerfile instructions with examples.

## FROM

```dockerfile
FROM <image>[:<tag>] [AS <stage>]
```

Sets the base image. Must be the first instruction (except ARGs before FROM). Use multi‑stage builds with `AS`.

## RUN

```dockerfile
RUN <command>                       # shell form
RUN ["executable", "param1", "param2"]  # exec form
```

Executes commands in a new layer. Use exec form to avoid signal issues.

## CMD

```dockerfile
CMD ["executable","param1","param2"]   # exec form (preferred)
CMD command param1 param2              # shell form
CMD ["param1","param2"]                # default arguments for ENTRYPOINT
```

Provides default command or arguments. Only one CMD per Dockerfile (last wins).

## LABEL

```dockerfile
LABEL version="1.0" maintainer="user@example.com"
```

Adds metadata to the image. Use multiple LABELs for clarity.

## EXPOSE

```dockerfile
EXPOSE 80/tcp
EXPOSE 53/udp
```

Documents the port. Does not publish the port (use `-p` at runtime).

## ENV

```dockerfile
ENV APP_HOME /usr/src/app
ENV VERSION=1.2.3
```

Sets environment variables. Persist both during build and in the container.

## ADD

```dockerfile
ADD https://example.com/file.tar.gz /tmp/
ADD myarchive.tar.gz /app/      # auto-extracts tar archives
```

Copies files from the build context or URL. Prefer COPY unless you need tar auto‑extraction.

## COPY

```dockerfile
COPY --chown=user:group src dst
COPY . /app
```

Copies files from the build context. Simpler and more transparent than ADD.

## ENTRYPOINT

```dockerfile
ENTRYPOINT ["executable", "param1"]
ENTRYPOINT command param1      # shell form
```

Configures the container as an executable. CMD then provides default arguments.

## VOLUME

```dockerfile
VOLUME /data
VOLUME ["/var/log", "/var/db"]
```

Creates a mount point and marks it as externally mounted. Data persists beyond container lifecycle.

## USER

```dockerfile
USER myuser:mygroup
```

Sets the user for subsequent RUN, CMD, and ENTRYPOINT.

## WORKDIR

```dockerfile
WORKDIR /app
```

Sets the working directory. If it doesn’t exist, it’s created. Can be used multiple times.

## ARG

```dockerfile
ARG BUILD_VERSION=1.0
RUN echo $BUILD_VERSION
```

Defines build‑time variables. Use `--build-arg` to pass values. Not persisted in the final image unless used in ENV.

## ONBUILD

```dockerfile
ONBUILD COPY . /usr/src/app
```

Adds a trigger that executes when the image is used as a base for another build. Rarely used.

## STOPSIGNAL

```dockerfile
STOPSIGNAL SIGTERM
```

Sets the system call signal to stop the container. Default is `SIGTERM`.

## HEALTHCHECK

```dockerfile
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost/ || exit 1
```

Tells Docker how to test a container’s health. Supports `CMD` and `NONE`.

## SHELL

```dockerfile
SHELL ["/bin/bash", "-c"]
```

Overrides the default shell for shell form instructions. Useful for Windows or alternative shells.

> 🔗 Next: [Build Context & .dockerignore](build-context-and-ignore.md)
