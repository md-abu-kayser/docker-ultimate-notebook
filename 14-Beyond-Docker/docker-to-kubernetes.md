# Migrating from Docker to Kubernetes

Moving from Docker Compose/Swarm to Kubernetes involves translating your deployment definitions and adapting your mental model.

## 1. Mapping Concepts

| Docker Compose       | Kubernetes                         |
| -------------------- | ---------------------------------- |
| Service              | Deployment + Service               |
| Container            | Pod (often 1 container)            |
| Ports                | Service / Ingress                  |
| Environment variable | ConfigMap / Secret                 |
| Volume               | PersistentVolumeClaim              |
| Network              | CNI plugin (Flannel, Calico)       |
| `depends_on`         | Init containers / readiness checks |

## 2. Using Kompose

Kompose converts `docker-compose.yml` into Kubernetes manifests.

```bash
kompose convert
```

This generates Deployment, Service, and PersistentVolumeClaim YAML files.

Limitations: Kompose handles simple cases but may require manual tuning for production.

## 3. Writing Kubernetes Manifests

### Deployment (simplified)

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
        - name: app
          image: myapp:1.2.3
          ports:
            - containerPort: 3000
```

### Service

```yaml
apiVersion: v1
kind: Service
metadata:
  name: myapp
spec:
  selector:
    app: myapp
  ports:
    - port: 80
      targetPort: 3000
```

## 4. Handling Configuration

Use **ConfigMaps** for non‑sensitive settings and **Secrets** for passwords.

```bash
kubectl create configmap app-config --from-file=config.yaml
kubectl create secret generic db-pass --from-literal=password=mypass
```

## 5. Data Persistence

Use PersistentVolumeClaims:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: myapp-data
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
```

## 6. Adapting Dockerfile

Docker images remain the same. No changes needed unless you want to optimize for K8s (e.g., adding readiness/liveness probes).

## 7. Learning Curve

- Use minikube or Kind for local development.
- Explore Helm for packaging.
- Adopt a GitOps tool like ArgoCD.

> 📘 Next: [Podman & Alternatives](podman-and-alternatives.md)
