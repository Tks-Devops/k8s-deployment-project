Markdown

# Python App Deployment on Kubernetes

This project demonstrates how to deploy a Python application on a Kubernetes cluster using Docker, Kubernetes YAML files, and Jenkins for CI/CD automation.

## Project Overview

The project includes:

- A Python script (`app.py`).
- A Dockerfile to containerize the application.
- Kubernetes YAML files for deployment, service, and horizontal pod autoscaling.
- A Jenkins pipeline script for automating the build and deployment process.

## Prerequisites

- AWS Free Tier account with an EC2 instance.
- Minikube or any Kubernetes cluster.
- Docker installed on the system.
- Jenkins set up for CI/CD.
- Git installed on the system.

## Steps to Set Up the Project

### 1. Python Script

Save the following Python script as `app.py`:

```python
# app.py
print("Hello, Kubernetes!")

2. Dockerfile

Create a Dockerfile to containerize the Python application:
Dockerfile

FROM python:3.7-slim
WORKDIR /app
COPY app.py .
CMD ["python", "app.py"]

3. Kubernetes YAML Files
Deployment
YAML

apiVersion: apps/v1
kind: Deployment
metadata:
  name: python-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: python-app
  template:
    metadata:
      labels:
        app: python-app
    spec:
      containers:
      - name: python-app
        image: <your-docker-image>:<build-number>
        ports:
        - containerPort: 5000

Service
YAML

apiVersion: v1
kind: Service
metadata:
  name: python-app-service
spec:
  selector:
    app: python-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 5000
  type: LoadBalancer

Horizontal Pod Autoscaler
YAML

apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: python-app-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: python-app
  minReplicas: 1
  maxReplicas: 5
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 50

4. Jenkins Pipeline Script

Automate the build and deployment process with the following Jenkins pipeline script:
Groovy

pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "your-docker-image"
        DOCKER_REGISTRY = "your-docker-registry"
        BUILD_NUMBER = "${BUILD_NUMBER}"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/your-username/your-repository.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${BUILD_NUMBER} .'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    sh 'docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${BUILD_NUMBER}'
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh 'kubectl apply -f deployment.yaml'
                    sh 'kubectl apply -f service.yaml'
                    sh 'kubectl apply -f hpa.yaml'
                }
            }
        }
    }
}

1 vulnerability detected

Steps to Deploy

    Clone this repository:

bash

git clone https://github.com/your-username/your-repository.git
cd your-repository

    Build the Docker image:

docker build -t <your-docker-image>:<build-number> .

    Push the Docker image to a registry:

docker push <your-docker-image>:<build-number>

    Apply the Kubernetes YAML files:

bash

kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl apply -f hpa.yaml

    Verify the deployment:

bash

kubectl get pods
kubectl get svc
kubectl get hpa
