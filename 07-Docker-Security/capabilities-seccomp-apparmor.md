# Linux Capabilities, Seccomp & AppArmor

Docker uses Linux kernel security modules to limit what a container can do, even if it runs as root.

## Linux Capabilities

The traditional `root` user has all privileges. Capabilities break these into smaller units. Docker drops many capabilities by default, only keeping a safe set.

### Default Capabilities

`CHOWN`, `DAC_OVERRIDE`, `FSETID`, `FOWNER`, `MKNOD`, `NET_RAW`, `SETGID`, `SETUID`, `SETFCAP`, `SETPCAP`, `NET_BIND_SERVICE`, `SYS_CHROOT`, `KILL`, `AUDIT_WRITE`

### Dropping and Adding Capabilities

```bash
docker run --cap-drop=ALL --cap-add=NET_BIND_SERVICE myapp
```

- Always start by dropping all capabilities.
- Add only what’s absolutely required.

### Common Capabilities to Remove

- `SYS_ADMIN` (very powerful)
- `NET_ADMIN` (network configuration)
- `SYS_PTRACE` (debugging)

## Seccomp (Secure Computing Mode)

Seccomp profiles filter which syscalls a container can make. Docker ships with a default seccomp profile that blocks ~44 syscalls out of 300+.

### Viewing the Default Profile

```bash
docker info | grep -i seccomp
```

### Disabling Seccomp (not recommended)

```bash
docker run --security-opt seccomp=unconfined ...
```

### Custom Seccomp Profile

Create a JSON profile:

```json
{
  "defaultAction": "SCMP_ACT_ALLOW",
  "syscalls": [
    {
      "name": "chmod",
      "action": "SCMP_ACT_ERRNO"
    }
  ]
}
```

Apply:

```bash
docker run --security-opt seccomp=/path/to/profile.json myapp
```

## AppArmor (Ubuntu/Debian) / SELinux (RHEL/CentOS)

Mandatory Access Control systems add another layer. Docker ships with a default AppArmor profile for containers.

### Using a Custom AppArmor Profile

1. Load the profile on host:
   ```bash
   sudo apparmor_parser -r -W /etc/apparmor.d/containers/my-profile
   ```
2. Apply to container:
   ```bash
   docker run --security-opt apparmor=my-profile myapp
   ```

### SELinux Labels (RHEL)

Docker automatically assigns an `MCS` label to containers. You can set custom labels:

```bash
docker run --security-opt label=user:myuser ...
```

## Best Practices

- Always run with default seccomp/AppArmor enabled.
- Drop all capabilities except those explicitly needed.
- Combine all three: capabilities + seccomp + AppArmor/SELinux.

> 📘 Next: [Read‑Only Filesystem](read-only-filesystem.md)
