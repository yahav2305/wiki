---
title: Multi Container Pods
draft: false
weight: 18
series:
  - Kubernetes
series_order: 18
---
We can run a pod with multiple containers
When there are multiple containers in the same pod:
- They are created together and die together.
- They share the same network space, allowing them to call each other easily.
- They share storage space, so no additional communication setup is needed between them.
# Example Use Case
A web service creates logs that need to be sent to a central service. Using another container for the central service agent to parse, edit, and send logs ensures scalability. An agent is created for every web service and destroyed with it, sharing storage and networking for easier log transfer.
# Types of Multi-Container Pods
- **Sidecar**: Adds functionality to the main container. Example: server log agent for a web service.
- **Adapter**: Changes the output of the main container to a standardized output.
- **Ambassador**: Enables communication between the main container and the outside world, functioning as a proxy.
The difference between these types lies in the approach to building the multi-container pod. The pod creation files remain the same.
# Multi-Container Pod Creation File
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: two-containers
spec:
  containers:
  # Container 1
  - name: nginx-container
    image: nginx
  # Container 2
  - name: debian-container
    image: debian
```