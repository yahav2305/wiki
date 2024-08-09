---
title: Viewing Logs
draft: false
weight: 20
series:
  - Kubernetes
series_order: 20
---
In Kubernetes, you can view logs at both the pod and container levels using `kubectl logs` commands. Here are the common commands for accessing logs:
# `Kubectl` commands

| Command                                       | Description                                                    |
| --------------------------------------------- | -------------------------------------------------------------- |
| `kubectl logs <pod-name>`                     | Print logs from the specified pod.                             |
| `kubectl logs <pod-name> <container-name>`    | Print logs from the specified pod in the specified container.  |
| `kubectl logs -f <pod-name>`                  | Stream logs from the specified pod.                            |
| `kubectl logs -f <pod-name> <container-name>` | Stream logs from the specified pod in the specified container. |
# Example Usage

To view logs from a pod named `my-pod`:
```sh
kubectl logs my-pod
```

To view logs from a specific container named `my-container` in the pod `my-pod`:
```sh
kubectl logs my-pod my-container
```

To stream logs from the pod `my-pod`:
```sh
kubectl logs -f my-pod
```

To stream logs from the container `my-container` in the pod `my-pod`:
```sh
kubectl logs -f my-pod my-container
```