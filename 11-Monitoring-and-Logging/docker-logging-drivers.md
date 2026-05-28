# Docker Logging Drivers

Docker supports multiple logging drivers to route container logs to different destinations. The default is `json-file`, which stores logs as JSON on the host.

## List of Built-in Drivers

| Driver       | Description                               |
| ------------ | ----------------------------------------- |
| `json-file`  | Default. JSON file on disk.               |
| `syslog`     | Writes to syslog.                         |
| `journald`   | Writes to systemd journal.                |
| `gelf`       | Graylog Extended Log Format (UDP).        |
| `fluentd`    | Sends to Fluentd collector.               |
| `awslogs`    | Amazon CloudWatch Logs.                   |
| `splunk`     | Splunk HTTP Event Collector.              |
| `etwlogs`    | Windows Event Tracing.                    |
| `gcplogs`    | Google Cloud Logging.                     |
| `logentries` | Rapid7 Logentries.                        |
| `local`      | Minimal local file with minimal overhead. |
| `none`       | Disables logging completely.              |

## Configuring the Default Driver

Edit `/etc/docker/daemon.json`:

```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
```

Restart Docker: `sudo systemctl restart docker`.

## Per-Container Driver

Override for a specific container:

```bash
docker run --log-driver=syslog --log-opt syslog-address=udp://1.2.3.4:514 nginx
```

## JSON File Options

- `max-size`: max size of each log file (e.g., `10m`, `100k`).
- `max-file`: number of log files to keep before rotation.
- `labels` and `env`: include metadata in log records.

## Fluentd Example

```bash
docker run --log-driver=fluentd --log-opt fluentd-address=localhost:24224 nginx
```

In Compose:

```yaml
logging:
  driver: fluentd
  options:
    fluentd-address: "fluentd:24224"
    tag: "docker.{{.Name}}"
```

## Disabling Logs

```bash
docker run --log-driver none ...
```

## Viewing Logs

```bash
docker logs <container>
docker logs --tail 50 -f <container>
```

Note: `docker logs` works only with `json-file` and `journald` drivers (and `local`). Other drivers require external tools.

> 📘 Next: [Centralized Logging with ELK](centralized-logging-with-elk.md)
