---
title: Volumes
draft: false
weight: 25
series:
  - Kubernetes
series_order: 25
---
Volumes in Kubernetes allow you to persist data beyond the lifecycle of a Pod. When a Pod is destroyed, its data is typically lost unless a volume is used. By attaching a volume to a Pod, you can store data that remains available even if the Pod is terminated or restarted.
# Volume Use Case Example

The following example demonstrates a simple Pod that generates a random number between 1 and 100, saving the result in a file stored on the host machine. The volume ensures that the generated number persists even if the Pod is destroyed.

Pod Configuration with HostPath Volume:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: random-number-generator
spec:
  containers:
  - image: alpine
    name: alpine
    command: ["/bin/sh", "-c"]
    args: ["shuf -i 0-100 -n 1 >> /opt/number.out;"]
    # Mount a volume on the container at the specified path (/opt)
    volumeMounts:
    - mountPath: /opt
      name: data-volume
# Define the volume and map it to a directory on the host
  volumes:
  - name: data-volume
    hostPath: 
      path: /data
      type: Directory
```
Key Elements:
- **`volumeMounts`**: This section defines where in the container's filesystem the volume will be mounted. In this example, the volume is mounted to `/opt` inside the container.
- **`volumes`**: This section defines the actual volume. In this case, a `hostPath` volume is used, which maps to the `/data` directory on the host machine.
- **`hostPath`**: This type of volume mounts a file or directory from the host node's filesystem into your Pod. This can be useful for sharing files between Pods or persisting data across Pod restarts. However, it's important to note that this ties the Pod to a specific node.

When this Pod runs, it will:
1. Generate a random number between 1 and 100.
2. Append this number to a file (`number.out`) in the `/opt` directory within the container.
3. The `/opt` directory inside the container is mapped to the `/data` directory on the host machine via the `hostPath` volume, meaning that the file will persist on the host machine.

This approach ensures that the generated number is saved and remains accessible even after the Pod is terminated, providing a basic mechanism for persistent storage within Kubernetes.