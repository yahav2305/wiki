---
title: Headless Service
draft: false
weight: 28
series:
  - Kubernetes
series_order: 28
---
StatefulSets are a type of Kubernetes resource used for managing stateful applications. Unlike Deployments, which handle stateless applications, StatefulSets maintain a fixed identity for each pod, ensuring stable network identifiers, persistent storage, and ordered scaling or deletion. This is particularly useful for databases like MySQL, where consistency and stable network identity are crucial for replication and data integrity.
# Key Features of StatefulSets
1. **Stable Network Identity**: Each pod in a StatefulSet has a unique and stable network identity (e.g., `mysql-0`, `mysql-1`), which persists through pod restarts and re-creations.
2. **Ordered Deployment and Scaling**: Pods are created, updated, or deleted in a sequential order. A new pod is only created or updated once the previous one is successfully running.
3. **Persistent Storage**: Pods in a StatefulSet can use PersistentVolumes (PVs) to retain their data even after they are deleted or rescheduled.
4. **Automatic DNS Setup**: StatefulSets automatically configure DNS entries for each pod, making it easier to manage communication between pods.
# Use Case: MySQL Server with Replication
When setting up a MySQL server with replication, it's important that each MySQL instance can reliably identify and communicate with its peers. Using StatefulSets ensures that even if the main server is destroyed and recreated, it retains the same network identity, allowing replicas to continue synchronizing with it.
# StatefulSet Configuration
Below is an example of a StatefulSet configuration for deploying a MySQL server with three replicas. This setup ensures that the pods are named consistently, even after restarts, and are deployed in an ordered manner.
## StatefulSet YAML Example
```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mysql
  labels:
    app: mysql
spec:
  replicas: 3
  serviceName: "mysql-h"  # Headless service to manage DNS entries
  podManagementPolicy: OrderedReady  # Ensures pods are created and deleted in order
  selector:
    matchLabels:
      app: mysql  # Must match the labels in the pod template
  template:
    metadata:
      labels:
        app: mysql  # Must match the selector's matchLabels
    spec:
      containers:
      - name: mysql
        image: mysql:5.7
        ports:
        - containerPort: 3306
        volumeMounts:
        - name: mysql-persistent-storage
          mountPath: /var/lib/mysql  # Path where MySQL stores its data
  volumeClaimTemplates:
  - metadata:
      name: mysql-persistent-storage
    spec:
      accessModes: [ "ReadWriteOnce" ]
      storageClassName: "my-storage-class"
      resources:
        requests:
          storage: 1Gi  # Each pod gets its own 1Gi storage
```
Explanation:
- **`replicas: 3`**: Specifies that three replicas of the MySQL server should be created.
- **`serviceName: "mysql-h"`**: A headless service that ensures the pods are accessible by a stable DNS name.
- **`podManagementPolicy: OrderedReady`**: Ensures that pods are created and deleted sequentially. The next pod is created only after the previous one is fully ready.
- **`volumeClaimTemplates`**: Defines the storage requirements for each pod. Each pod gets its own PersistentVolume with 1Gi of storage, ensuring that data is retained across pod restarts.
Notes:
- When a pod in a stateful set is destroyed, its persistent volume isn’t destroyed. The persistent volume will wait for its pod to come back.
# Headless Service
A headless service is required to manage the DNS entries for the StatefulSet pods. This service allows each pod to be addressed individually (e.g., `mysql-0.mysql-h.<namespace>.svc.cluster.local`, `mysql-1.mysql-h.<namespace>.svc.cluster.local`).
## Headless Service YAML Example
```yaml
apiVersion: v1
kind: Service
metadata:
  name: mysql-h
  labels:
    app: mysql
spec:
  ports:
  - port: 3306
    name: mysql
  clusterIP: None  # Indicates a headless service
  selector:
    app: mysql
```