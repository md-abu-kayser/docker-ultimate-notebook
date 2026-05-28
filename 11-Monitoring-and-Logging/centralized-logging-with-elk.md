# Centralized Logging with the ELK Stack

The ELK stack (Elasticsearch, Logstash, Kibana) – often extended to Elastic Stack with Beats – is a powerful solution for collecting, processing, and visualizing logs from Docker containers.

## Architecture Overview

```
Containers (stdout/stderr)
    ↓
Fluentd / Logstash / Filebeat
    ↓
Elasticsearch (storage)
    ↓
Kibana (visualization)
```

## Option 1: Fluentd + Elasticsearch + Kibana

### Docker Compose Setup

```yaml
version: "3.8"
services:
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:8.11.0
    environment:
      - discovery.type=single-node
      - xpack.security.enabled=false
    volumes:
      - es_data:/usr/share/elasticsearch/data
    ports:
      - "9200:9200"

  kibana:
    image: docker.elastic.co/kibana/kibana:8.11.0
    environment:
      - ELASTICSEARCH_HOSTS=http://elasticsearch:9200
    ports:
      - "5601:5601"
    depends_on:
      - elasticsearch

  fluentd:
    image: fluent/fluentd:v1.16
    volumes:
      - ./fluentd/conf:/fluentd/etc
    ports:
      - "24224:24224"
    depends_on:
      - elasticsearch

volumes:
  es_data:
```

Fluentd configuration (`fluentd/conf/fluent.conf`):

```
<source>
  @type forward
  port 24224
  bind 0.0.0.0
</source>

<match **>
  @type elasticsearch
  host elasticsearch
  port 9200
  logstash_format true
</match>
```

Run containers with Fluentd driver:

```bash
docker run --log-driver=fluentd --log-opt fluentd-address=localhost:24224 --log-opt tag="app" myapp
```

## Option 2: Filebeat + Elasticsearch + Kibana

Filebeat can read Docker container logs from the default `json-file` location.

Filebeat `filebeat.yml`:

```yaml
filebeat.inputs:
  - type: container
    paths:
      - "/var/lib/docker/containers/*/*.log"

output.elasticsearch:
  hosts: ["elasticsearch:9200"]
```

Mount the Docker socket and log directory into the Filebeat container.

## Kibana Setup

- Access `http://localhost:5601`.
- Create index pattern (e.g., `logstash-*` or `filebeat-*`).
- Use Discover and Dashboard to analyze logs.

## Production Considerations

- Secure Elasticsearch with authentication/SSL.
- Use persistent volumes for Elasticsearch data.
- Tune heap size (`ES_JAVA_OPTS=-Xms1g -Xmx1g`).
- Use log rotation and retention policies.

> 📘 Next: [Monitoring with Prometheus & Grafana](monitoring-with-prometheus-grafana.md)
