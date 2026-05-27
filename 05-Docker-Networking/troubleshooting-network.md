# Troubleshooting Docker Networking

## Common Issues & Solutions

### 1. Container Cannot Reach the Internet

- Check if container can resolve DNS: `docker exec <container> nslookup google.com`.
- If DNS fails, check `/etc/resolv.conf` inside the container (Docker copies host’s DNS or uses `--dns`).
- For user‑defined bridge, ensure the gateway is set correctly.
- Host firewall may be blocking forwarding: `iptables -L -n` on Linux; ensure `FORWARD` chain allows Docker.

### 2. Cannot Access Published Port from Host

- `docker ps` shows port mapping correctly? If using `-P`, check `docker port`.
- Firewall rules (ufw, firewalld) may be blocking.
- On macOS/Windows, published ports are only reachable via `localhost` (Docker runs in a VM). Use `localhost:port`.

### 3. Inter‑Container Communication Fails

- Are they on the same network? `docker network inspect <net>`.
- For user‑defined bridge, use service names. Ping by name: `ping <service-name>`.
- If pinging by IP works but name fails, DNS might be disabled (unlikely). Try `--dns` or check embedded DNS (`127.0.0.11`).

### 4. Overlay Network Issues (Swarm)

- Ensure all nodes have the same network.
- Verify gossip ports (7946) and VXLAN (4789) are open.
- Check overlay encryption if performance is poor.

### 5. Macvlan/IPvlan Host Communication

- Host cannot ping macvlan containers by default. Workaround: create a macvlan sub‑interface on the host with an IP in the same subnet.

## Useful Diagnostic Commands

```bash
docker network ls
docker network inspect <net>
docker exec <container> ip addr
docker exec <container> ip route
docker run --rm --net=host nicolaka/netshoot    # network troubleshooting toolkit
```

## Using `netshoot`

`docker run --rm -it nicolaka/netshoot` gives you a container with all network tools (curl, ping, nslookup, tcpdump, iptables, etc.).

## Container DNS Debugging

```bash
docker exec <container> cat /etc/resolv.conf
```

Embedded DNS server is at `127.0.0.11`. All queries to it are forwarded to the host’s DNS.

## Firewall Pitfalls on Linux

Docker modifies `iptables`. Using `ufw` with Docker often causes conflicts. If using `ufw`, set `DEFAULT_FORWARD_POLICY="ACCEPT"` in `/etc/default/ufw`.

> 📘 Next: **06‑Docker‑Storage** – starting with [Volumes vs Bind Mounts](../06-Docker-Storage/volumes-vs-bind-mounts.md)
