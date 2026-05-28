# Image Tagging Strategy for Production

Consistent and immutable tagging is critical for traceability, rollback, and compliance.

## Golden Rules

- **Never use `:latest` in production.**
- **Always use immutable tags** (digests or unique version IDs).
- **Promote images**, don’t rebuild for each environment.

## Recommended Tagging Scheme

```
myapp:<semver>
myapp:<git-commit>
myapp:<build-id>
```

Examples:

- `myapp:1.4.2`
- `myapp:git-abc1234`
- `myapp:build-42`

Push multiple tags for the same image:

```bash
docker build -t myapp:1.4.2 -t myapp:git-$(git rev-parse --short HEAD) .
docker push myapp:1.4.2
docker push myapp:git-abc1234
```

## Using Digests

After pushing, note the digest and use that for deployments:

```bash
docker pull myapp@sha256:def456...
```

Digests are the ultimate immutable reference.

## Environment‑Specific Tags (Mutable)

Avoid promoting by tag name alone; instead:

- `staging` tag is updated on each staging deploy.
- `production` tag points to the current production image.
  Use these for convenience but always know the underlying version.

## CI/CD Integration

- CI builds produce images tagged with the git commit SHA.
- When tests pass, retag that image with a semver and push.
- Deployment tooling refers to the semver or commit SHA.

## Registry Cleanup

Implement a retention policy to remove old and unused tags to save storage and reduce clutter.

## Example Workflow

1. Developer pushes to main → CI builds `app:git-abc`.
2. CI runs tests → passes → retags as `app:1.2.3-beta.1`.
3. Manual approval → promote to `app:1.2.3` and `app:latest` (only for dev convenience).
4. Deploy `app:1.2.3` to production.

## Security

- Sign images before tagging for production.
- Use Docker Content Trust or Cosign.

> 📘 Next: [Restart Policies](restart-policies.md)
