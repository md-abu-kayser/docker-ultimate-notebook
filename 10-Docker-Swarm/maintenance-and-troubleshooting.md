# Swarm Maintenance & Troubleshooting

Keep your Swarm cluster healthy and debug common issues.

## Node Maintenance

### Draining a Node

```bash
docker node update --availability drain <node>
```

All tasks are rescheduled to other nodes. Perform system updates, reboot, then reactivate:

```bash
docker node update --availability active <node>
```

### Removing a Node

- On the node: `docker swarm leave`
- On a manager: `docker node rm <node>` (for down nodes, use `--force`)

### Recovering from a Lost Manager

If you lose the majority of managers, you can’t manage the swarm. Restore from backup or reinitialize.

- Force a new cluster: `docker swarm init --force-new-cluster` on a surviving manager node.

## Backup & Restore

- Swarm state is stored in `/var/lib/docker/swarm/` on managers.
- Stop Docker on the manager, back up that directory.
- To restore, replace the directory and start Docker.

## Common Issues

### 1. Overlay Network Issues

- Symptoms: containers can’t communicate across nodes.
- Check firewall: UDP 4789, TCP/UDP 7946 must be open.
- Verify network: `docker network inspect <network>`.

### 2. DNS Resolution Fails

- Embedded DNS at `127.0.0.11`.
- Check if `--dns` or `dns` config overrides.
- Restart Docker daemon if resolver hangs.

### 3. Service Fails to Start / Stuck in Pending

- `docker service ps --no-trunc` shows error messages.
- Check resource constraints.
- Ensure images are available on all nodes.

### 4. Split Brain (Multiple Managers)

- Avoid using an even number of managers.
- If split, determine which group has the majority and force a new cluster if needed.

### 5. Port Conflicts

- Published ports are taken on all nodes. Only one service can bind to a host port.

## Logs & Debugging

- `docker service logs <service>` – aggregated logs.
- `journalctl -u docker` – daemon logs.
- Use `docker node inspect` and `docker service inspect` for state details.

## Monitoring Swarm Health

- Use Prometheus to scrape metrics from Docker daemon (`--metrics-addr`).
- Monitor manager Raft logs, service replication, and node availability.

## Upgrading Swarm

- Upgrade Docker Engine on all nodes (managers first, then workers).
- Drain managers one by one to ensure quorum.

> 🎉 Congratulations! You’ve completed the **Docker Swarm** section.

> 📘 Ready to dive in? Head over to **11‑Monitoring‑and‑Logging** starting with [11‑Docker Logging](../11-Monitoring-and-Logging/docker-logging-drivers.md)
