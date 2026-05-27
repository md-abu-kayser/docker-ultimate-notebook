# Docker Storage Drivers

Storage drivers handle the union filesystem that combines image layers into a container’s view.

## Default Driver: `overlay2`

- Recommended for all modern Linux distributions.
- Uses OverlayFS from the kernel.
- Efficient copy‑on‑write.

Check current driver:

```bash
docker info | grep "Storage Driver"
```

## Common Drivers

| Driver          | Description                                                          |
| --------------- | -------------------------------------------------------------------- |
| `overlay2`      | Preferred; supports xattr, inode index. Kernel 4.0+.                 |
| `aufs`          | Older; was default for Ubuntu. Deprecated.                           |
| `devicemapper`  | For RHEL/CentOS with LVM; not recommended.                           |
| `btrfs` / `zfs` | Allow snapshots and advanced features, but require filesystem setup. |
| `vfs`           | No copy‑on‑write; each layer is fully copied. Only for testing.      |

## Changing Storage Driver

Requires stopping Docker, removing all data, and editing `daemon.json`:

```json
{
  "storage-driver": "overlay2"
}
```

Then restart Docker. **Backup images first**.

## Overlay2 Details

- Uses multiple lower directories (layers) and an upper directory (container layer).
- A merged directory provides the unified view.
- Supports `redirect_dir` and `index=off` for performance.

## Filesystem Compatibility

- `overlay2` requires `xfs` with `ftype=1` (default on most distros) or `ext4`.
- `btrfs`/`zfs` require the backing filesystem to be of that type.

## Disk Space Management

- Storage driver handles layer sharing; images share common layers.
- Use `docker system df -v` to see detailed usage.
- `docker image prune -a` removes unused images and layers.

## Choosing a Driver

- For most: stick with `overlay2`.
- If you need advanced snapshot capabilities, consider `btrfs` or `zfs`.

> 🔗 Next: [Data Persistence Strategies](data-persistence.md)
