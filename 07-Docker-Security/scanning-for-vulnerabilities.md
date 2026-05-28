# Scanning Images for Vulnerabilities

Regular vulnerability scanning is essential to catch known CVEs in your images.

## Popular Scanning Tools

| Tool             | Description                                      |
| ---------------- | ------------------------------------------------ |
| **Trivy**        | Open source, fast, comprehensive (Aqua Security) |
| **Snyk**         | Developer‑friendly, integrates with CI/CD        |
| **Docker Scout** | Built‑in Docker Desktop / Hub analysis           |
| **Grype**        | Lightweight, from Anchore                        |
| **Clair**        | Static analysis for vulnerabilities              |

## Using Trivy

```bash
# Install
brew install trivy   # macOS
# or
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh

# Scan an image
trivy image nginx:alpine

# Scan with severity filter
trivy image --severity HIGH,CRITICAL myapp:latest

# Scan filesystem or Git repo
trivy fs /path/to/project
```

## Trivy Output Options

- Table, JSON, SARIF, HTML.
- Use `--format json -o result.json` for automation.

## Integrating Scans into CI/CD

```bash
trivy image --exit-code 1 --severity CRITICAL myapp:latest
```

Non‑zero exit code fails the pipeline.

## Docker Scout

```bash
docker scout quickview myapp:latest
docker scout cves myapp:latest
docker scout recommendations myapp:latest
```

Available directly in Docker CLI (plugin). Also shows base image refresh recommendations.

## Image Patching

- Rebuild the image with updated base or packages.
- Automate rebuilds with tools like Dependabot, Renovate.
- Use minimal base images to reduce vulnerability surface.

## Best Practices

- Scan images as part of the build pipeline.
- Block deployment of images with CRITICAL vulnerabilities.
- Regularly update base images.
- Monitor runtime containers for newly discovered CVEs.

## SBOM (Software Bill of Materials)

Generate an SBOM to list all components:

```bash
trivy image --format cyclonedx --output sbom.json myapp:latest
syft myapp:latest -o spdx-json > sbom.json
```

> 📘 Next: [Secrets Management](secrets-management.md)
