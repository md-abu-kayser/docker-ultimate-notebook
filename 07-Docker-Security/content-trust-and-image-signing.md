# Content Trust & Image Signing

Docker Content Trust (DCT) ensures the integrity and publisher of images using digital signatures.

## What Is Docker Content Trust?

- Uses **Notary** to sign and verify image tags.
- Each signed tag has a cryptographic signature linking it to a publisher key.
- Enabled by setting `DOCKER_CONTENT_TRUST=1`.

## Enabling Content Trust

```bash
export DOCKER_CONTENT_TRUST=1
docker pull alpine:3.18   # only pulls if signed
docker push myrepo/myapp:latest  # pushes with signature
```

## How It Works

- When you push with DCT enabled, Docker signs the tag with a repository key.
- The key is stored in `~/.docker/trust/private/`.
- When pulling, Docker verifies the signature against the published key.

## Docker Trust Commands

```bash
docker trust key generate mykey
docker trust signer add --key mykey.pub user repo/name
docker trust inspect --pretty repo/name:tag
docker trust revoke repo/name:tag
```

## Signing with a Delegation

Delegations allow multiple signers:

```bash
docker trust signer add --key developer.pub alice repo/app
docker trust sign repo/app:1.0
```

## CI/CD Integration

- Load the repository key into CI (as a secret).
- Sign images during the pipeline after build and test.
- Never commit keys; use environment variables or secret stores.

## Verification on Pull

When `DOCKER_CONTENT_TRUST=1`:

- `docker pull` checks signatures.
- `docker run` of an unsigned image will fail.
- You can set this globally in Docker daemon config.

## Limitations

- Requires Notary server (Docker Hub includes one).
- Extra complexity; not all registries support it.
- Only tags are signed, not digests (but you can sign a digest tag).

## Alternatives

- **Cosign** (Sigstore): signs OCI artifacts without a Notary server.
- **Notation** (from Notary v2): lightweight signing for OCI images.

> 📘 Next: [Scanning for Vulnerabilities](scanning-for-vulnerabilities.md)
