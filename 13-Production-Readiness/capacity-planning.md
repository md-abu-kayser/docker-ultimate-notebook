# Capacity Planning for Docker

Capacity planning ensures your Docker hosts have enough resources to run workloads efficiently and survive spikes.

## 1. Understand Resource Requirements

- **CPU**: how many cores does each service need?
- **Memory**: average and peak usage.
- **Storage**: volume sizes, image storage, logs.
- **Network**: bandwidth per container.

## 2. Profiling Applications

Use `docker stats` to observe real‑time usage:

```bash
docker stats --all --no-stream
```

Use monitoring tools (Prometheus/cAdvisor) to gather historical data.

## 3. Setting Limits

Always set memory limits to prevent a single container from starving others:

```bash
docker run --memory=512m --cpus=1.5 myapp
```

Reserve resources for critical services using `--reserve-cpu` and `--reserve-memory` in Swarm.

## 4. Overcommitment Ratios

- **CPU**: you can overcommit heavily (many containers with `--cpus` sum > physical cores), but under load, performance degrades.
- **Memory**: overcommitment leads to OOM kills. Avoid overcommitting memory.

## 5. Node Sizing

- For Swarm clusters, ensure worker nodes have enough resources for the services they run.
- Use placement constraints to distribute loads.

## 6. Auto‑Scaling

Swarm doesn’t auto‑scale; you must build custom scripts or use external tools (e.g., Prometheus + Alertmanager triggering a webhook that runs `docker service scale`).
Kubernetes offers HPA, which is a reason many move to K8s for auto‑scaling.

## 7. Storage Growth

- Use `docker system df` to monitor disk usage.
- Implement log rotation and retention.
- Prune unused images and volumes regularly.

## 8. Capacity Testing

Perform load testing with tools like `wrk` or `k6` while monitoring metrics. Adjust limits accordingly.

## 9. High Availability

- Deploy multiple replicas of stateless services.
- Use Swarm manager quorum for control plane HA.
- Distribute services across availability zones.

## 10. Documentation

Keep a capacity runbook with expected resource consumption for each service.

> 🎉 Congratulations! You’ve completed the **Production Readiness** section.

> 📘 Ready to dive in? Head over to **14‑Beyond‑Docker** starting with [Kubernetes vs Swarm](../14-Beyond-Docker/kubernetes-vs-swarm.md)
