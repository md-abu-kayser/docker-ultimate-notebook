# Docker CI/CD with Jenkins

Jenkins can build and push Docker images using the Docker Pipeline plugin.

## Prerequisites

- Jenkins with Docker Pipeline plugin installed.
- Docker daemon accessible from Jenkins agent (via socket or TCP).

## Declarative Pipeline Example

```groovy
pipeline {
    agent any

    environment {
        REGISTRY = 'myregistry.example.com'
        IMAGE_NAME = 'myapp'
        TAG = "${env.BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/myorg/myapp.git'
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    docker.build("${REGISTRY}/${IMAGE_NAME}:${TAG}")
                }
            }
        }

        stage('Docker Push') {
            steps {
                script {
                    docker.withRegistry("https://${REGISTRY}", 'registry-credentials') {
                        docker.image("${REGISTRY}/${IMAGE_NAME}:${TAG}").push()
                        docker.image("${REGISTRY}/${IMAGE_NAME}:${TAG}").push('latest')
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                sshagent(['deploy-key']) {
                    sh """
                        ssh user@server "docker pull ${REGISTRY}/${IMAGE_NAME}:${TAG} && docker service update --image ${REGISTRY}/${IMAGE_NAME}:${TAG} myapp_service"
                    """
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
```

## Using docker-compose in Jenkins

```groovy
stage('Test & Deploy') {
    steps {
        sh 'docker compose -f docker-compose.test.yml up --exit-code-from test'
        sh 'docker compose -f docker-compose.prod.yml pull'
        sh 'docker stack deploy -c docker-compose.prod.yml myapp'
    }
}
```

## Caching Layer in Jenkins

Mount a persistent volume for Docker cache:

```groovy
agent {
    docker {
        image 'docker:latest'
        args '-v /var/run/docker.sock:/var/run/docker.sock -v /tmp/docker-cache:/root/.cache'
    }
}
```

Then use `--cache-from` during build.

## Using Buildx for Multi‑Arch

```groovy
stage('Build Multi-Arch') {
    steps {
        sh '''
            docker buildx create --use
            docker buildx build --platform linux/amd64,linux/arm64 -t ${REGISTRY}/${IMAGE_NAME}:${TAG} --push .
        '''
    }
}
```

## Secret Management

- Use Jenkins Credentials Binding plugin to inject secrets.
- Never store secrets in the pipeline script.

## Best Practices

- Use `docker.withRegistry` and credentials store for registry authentication.
- Run Jenkins agents as ephemeral Docker containers.
- Scan images with Trivy or Snyk as a pipeline stage.
- Clean up old images with `docker image prune` (with caution).

> 🎉 Congratulations! You’ve completed the **CICD Docker** section.

> 📘 Ready to dive in? Head over to **10‑Docker‑Swarm** starting with [Swarm Concepts](../10-Docker-Swarm/swarm-concepts.md)
