---
title: Resource Requests and Limits
draft: false
weight: 13
series:
  - Kubernetes
series_order: 13
---
When you specify a Pod, you can optionally specify how much of each resource a container needs. The most common resources to specify are CPU and memory (RAM); there are others.
# Requests
To define how many resources the container needs, specify it in the pod definition file under `spec.containers.resources.requests`:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-pod
spec:
  containers:
  - name: nginx
    image: nginx
    resources:
      requests:
        memory: "1Gi"
        cpu: "1"
```
- 1 CPU = 1 AWS vCPU = 1 GCP core = 1 Azure core = 1 Hyperthread
- Minimum CPU request: 0.1 CPU (0.001 CPU = 1 mCPU)
- 1K (kilobytes) = 1000 bytes
- 1Ki (kibibytes) = 1024 bytes
# Limits
To define the maximum resources a container should use, specify it in the pod definition file under `spec.containers.resources.limits`:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-pod
spec:
  containers:
  - name: nginx
    image: nginx
    resources:
      limits:
        memory: "2Gi"
        cpu: "2"
```
# Applying Kubernetes Resource Limits

In the event that a container tries to use more resources than it is allocated:
- **CPU**: The container will be throttled.
- **Memory**: The container will be killed.