# Placement Constraints & Preferences

Control where Swarm schedules tasks using constraints and placement preferences.

## Node Labels

Assign custom labels to nodes:

```bash
docker node update --label-add env=prod node1
docker node update --label-add disk=ssd node2
```

## Constraints

Restrict tasks to nodes that match a condition.

```bash
docker service create \
  --name app \
  --constraint node.labels.env==prod \
  --constraint node.role==worker \
  nginx
```

### Available Constraints

- `node.id`
- `node.hostname`
- `node.role` (manager/worker)
- `node.labels.<key>`
- `engine.labels.<key>`

## Placement Preferences

Distribute tasks according to a preference (soft constraint).

```bash
docker service create \
  --name app \
  --placement-pref 'spread=node.labels.datacenter' \
  nginx
```

Swarm tries to spread tasks evenly across values of the label, but if impossible, schedules anywhere.

## In Compose

```yaml
services:
  app:
    deploy:
      placement:
        constraints:
          - node.labels.env == prod
          - node.role == worker
        preferences:
          - spread: node.labels.az
```

## Use Cases

- Pin database services to nodes with SSD.
- Isolate dev/staging/prod on separate nodes.
- Ensure managers don’t run workloads (`node.role==worker`).

## Node Availability

- `active`: can schedule.
- `drain`: tasks are rescheduled, no new tasks.
- `pause`: existing tasks remain, no new tasks.

```bash
docker node update --availability drain node2
```

## Resource‑Aware Scheduling (experimental)

Swarm can consider CPU/memory limits for placement but it’s not a full‑fledged resource scheduler. Use `--reserve-cpu` and `--reserve-memory`.

## Example: Multi‑AZ Deployment

Label nodes by availability zone, then use spread preference to distribute replicas.

> 🔗 Next: [Rolling Updates & Rollback](rolling-updates-and-rollback.md)
