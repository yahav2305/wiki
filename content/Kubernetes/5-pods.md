---
title: 'What is Kubernetes'
draft: false
---
# Table of Contents

- [Pods](#pods)
	- [Pod Commands with Kubectl](#pod-commands-with-kubectl)
	- [Pod Creation YAML](#pod-creation-yaml)

# Pods

Pods are the fundamental unit of deployment in Kubernetes. They encapsulate one or more containerized applications and the resources they need to run.

Here's a breakdown of key pod concepts:

- **Smallest Deployable Unit:** Pods are the smallest building block that you can create and manage in Kubernetes.
- **Containerized Applications:** Pods package one or more containers that share storage and network resources. These containers typically work together to perform a specific function.
- **Isolation:** While containers from the same image can run on different pods for better isolation, containers within a pod share the same fate. If one container in a pod crashes or terminates, the entire pod is restarted.
- **Shared Resources:** Containers in a pod share storage (through volumes) and network resources. This enables them to communicate and collaborate seamlessly.

## Pod Commands with Kubectl

- **Creating pod:**
	- `kubectl run <pod-name> --image <image-name>`
    - This command creates a pod with the specified name (`<pod-name>`) running the container image (`<image-name>`).
- **Viewing Pods:**
    - `kubectl get pods`
    - This command displays a list of all pods in the Kubernetes cluster and namespace.

## Pod Creation YAML

The provided YAML snippet demonstrates how to define a pod in a YAML file:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: nginx:1.14.2
    ports:
    - containerPort: 80
```

- **apiVersion:** Specifies the Kubernetes API version used for the pod object.
- **kind:** Indicates the type of object being defined (in this case, a Pod).
- **metadata:** Provides details about the pod, including its name (`nginx`).
- **spec:** Defines the desired state of the pod, including the container configuration.
    - **containers:** An array containing details about the containers within the pod.
        - **name:** The name assigned to the container within the pod (here, `nginx`).
        - **image:** The container image to be used (e.g., `nginx:1.14.2`).
        - **ports:** An array specifying ports to be exposed by the container (here, port `80` is exposed).