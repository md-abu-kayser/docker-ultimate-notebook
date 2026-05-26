# Dockerfile Basics

A Dockerfile is a text document that contains instructions for building a Docker image.

## Simple Example

```dockerfile
# Use an official Python runtime as parent image
FROM python:3.11-slim

# Set the working directory
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Make port 80 available to the outside
EXPOSE 80

# Define environment variable
ENV NAME World

# Run app.py when the container launches
CMD ["python", "app.py"]
```

## Key Instructions

- **FROM**: base image (required).
- **WORKDIR**: set working directory for subsequent instructions.
- **COPY**: copy files from host to image.
- **RUN**: execute commands during build.
- **EXPOSE**: document the port the container listens on.
- **ENV**: set environment variables.
- **CMD**: default command to run when container starts.
- **ENTRYPOINT**: configure container as executable.

## Build the Image

```bash
docker build -t my-python-app .
```

- `-t` tags the image.
- `.` is the build context (directory with Dockerfile).

## Best Practices for Beginners

- Use official base images.
- Combine RUN commands with `&&` to reduce layers.
- Copy only necessary files.
- Use `.dockerignore` to exclude unnecessary files.

## Difference Between CMD and ENTRYPOINT

- `CMD` provides default arguments; can be overridden at runtime.
- `ENTRYPOINT` defines the executable; arguments passed at `docker run` are appended.
- Combine them: `ENTRYPOINT ["python"]` + `CMD ["app.py"]`.

> 🔗 Next: [Dockerfile Instructions Reference](dockerfile-instructions-reference.md)
