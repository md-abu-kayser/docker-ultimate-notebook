# Host, Macvlan, and IPvlan Drivers

These drivers give containers direct access to the host’s network interfaces, bypassing most virtualization.

## Host Driver

- Container shares the host’s network namespace.
- No network isolation: `localhost` inside the container = host’s `localhost`.
- No port mapping needed; container uses host ports directly.

```bash
docker run --network host nginx
```

Access via `http://host-ip:80`.

**Use case**: maximum network performance, network‑intensive applications, monitoring agents.

**Caution**: Port conflicts are common; only one container can bind to a port.

## Macvlan Driver

- Each container gets a unique MAC address and appears as a separate physical device on the network.
- Ideal for legacy apps that expect a real network interface.

### Bridge Mode (most common)

Container traffic goes through the parent interface, but each container has its own MAC.

```bash
docker network create -d macvlan \
  --subnet=192.168.1.0/24 \
  --gateway=192.168.1.1 \
  -o parent=eth0 my-macvlan
```

Run container:

```bash
docker run --network my-macvlan --ip=192.168.1.100 nginx
```

The container is directly reachable at 192.168.1.100 on your LAN.

### 802.1q Trunk Mode

For VLANs: `-o parent=eth0.10` (sub‑interface).

**Limitations**:

- Host cannot communicate with macvlan containers directly (need a workaround with sub‑interface or routing).
- MAC addresses must be unique; some switches have limits.

## IPvlan Driver

- Similar to macvlan but all containers share the parent’s MAC address, avoiding MAC table limits.
- Two modes:
  - **L2** (layer 2): default, same broadcast domain.
  - **L3** (layer 3): Docker acts as a router; containers have IPs from a different subnet.

Create IPvlan L2:

```bash
docker network create -d ipvlan \
  --subnet=192.168.1.0/24 \
  -o parent=eth0 my-ipvlan
```

The host still cannot directly reach containers without routing.

**When to use IPvlan**: when MAC address limits are an issue, or when the switch enforces port security.

> 🔗 Next: [Troubleshooting Network Issues](troubleshooting-network.md)
