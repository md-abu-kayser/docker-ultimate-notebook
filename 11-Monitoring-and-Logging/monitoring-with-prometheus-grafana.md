# Monitoring Docker with Prometheus & Grafana

Prometheus collects metrics, and Grafana visualizes them. Together they provide powerful container and host monitoring.

## Enabling Docker Metrics

The Docker daemon can expose metrics in Prometheus format.

Edit `/etc/docker/daemon.json`:

```json
{
  "metrics-addr": "0.0.0.0:9323",
  "experimental": true
}
```

Restart Docker. Test: `curl localhost:9323/metrics`.

## cAdvisor (Container Advisor)

cAdvisor provides detailed per-container metrics (CPU, memory, network, disk I/O).

```bash
docker run -d \
  --name=cadvisor \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:ro \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --publish=8080:8080 \
  gcr.io/cadvisor/cadvisor:latest
```

## Prometheus Setup

`prometheus.yml`:

```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: "docker"
    static_configs:
      - targets: ["host.docker.internal:9323"] # or <host-ip>:9323

  - job_name: "cadvisor"
    static_configs:
      - targets: ["cadvisor:8080"]

  - job_name: "node"
    static_configs:
      - targets: ["node-exporter:9100"]
```

Docker Compose:

```yaml
services:
  prometheus:
    image: prom/prometheus:latest
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    ports:
      - "9090:9090"

  grafana:
    image: grafana/grafana:latest
    ports:
      - "3000:3000"
    depends_on:
      - prometheus
```

## Node Exporter (Host Metrics)

```bash
docker run -d --name node-exporter --pid=host --network=host prom/node-exporter:latest
```

## Grafana Configuration

- Add Prometheus as data source (URL: `http://prometheus:9090`).
- Import dashboards:
  - Docker monitoring: ID `193` (or `179`).
  - cAdvisor: ID `14282`.
  - Node Exporter: ID `1860`.

## Alerting

Configure Alertmanager in Prometheus for resource alerts (high CPU, memory, container restarts).

## Best Practices

- Store Prometheus data on a persistent volume.
- Set retention period (`--storage.tsdb.retention.time=15d`).
- Use separate monitoring stack in production environments.

> 📘 Next: [Health Checks](health-checks.md)
