# Running Your First Docker Container

Time to get hands‑on. We’ll run, interact with, and manage your first container step by step.

## 1. Run a Simple Hello World

```bash
docker run hello-world
```

This pulls the `hello-world` image (if not present) and runs a container that prints a message, then exits. It confirms Docker is working.

## 2. Run an Interactive Ubuntu Shell

```bash
docker run -it ubuntu:22.04 bash
```

You’re now inside a minimal Ubuntu environment as `root`. Try:

```bash
cat /etc/os-release
apt-get update
apt-get install -y curl
exit
```

After `exit`, the container stops. To see stopped containers:

```bash
docker ps -a
```

## 3. Run a Detached Container (Background)

Let’s start an Nginx web server in detached mode:

```bash
docker run -d -p 8080:80 --name my-nginx nginx:alpine
```

- `-d` = run in the background.
- `-p 8080:80` = map host port 8080 to container port 80.
- `--name` = assign a name.

Visit `http://localhost:8080`. You should see the Nginx welcome page.

Check running containers:

```bash
docker ps
```

## 4. Access a Running Container

```bash
docker exec -it my-nginx sh
```

You can now explore the container’s filesystem. Type `exit` to leave without stopping it.

## 5. View Logs

```bash
docker logs my-nginx           # standard logs
docker logs -f my-nginx        # follow (tail -f)
```

## 6. Stop and Start Containers

```bash
docker stop my-nginx           # gracefully stop
docker start my-nginx          # restart a stopped container
```

## 7. Remove the Container

```bash
docker rm -f my-nginx          # force remove even if running
```

## Experiment: Run a Transient Container for a One‑Off Task

```bash
docker run --rm alpine ping -c 4 google.com
```

`--rm` automatically removes the container after it exits, perfect for temporary tasks.

## What You Learned

- `docker run` options: `-it`, `-d`, `-p`, `--name`, `--rm`.
- How to exec into a running container.
- How to manage container lifecycle (start, stop, rm).

> 🔗 Next: [Basic Docker Commands Cheatsheet](basic-commands.md)
