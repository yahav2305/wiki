---
title: Persistent Volumes & Persistent Volume Claims
draft: false
weight: 26
series:
  - Kubernetes
series_order: 26
---
Kubernetes provides a way to manage persistent storage using **Persistent Volumes (PV)** and **Persistent Volume Claims (PVC)**. These abstractions allow you to decouple storage management from Pod management, enabling more flexible and resilient storage solutions.
# Persistent Volume (PV)
A Persistent Volume is a piece of storage in the cluster that has been provisioned by an administrator. It is a cluster resource that is independent of any individual Pod.

Persistent Volume Creation File:
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-vol1
spec:
  accessModes:
  - ReadWriteOnce  # Access modes: ReadOnlyMany, ReadWriteOnce, ReadWriteMany
  capacity:
    storage: 1Gi  # Capacity of the volume
  hostPath:  # Volume location on the host
    path: /tmp/data
  persistentVolumeReclaimPolicy: Recycle  # Reclaim policy: Retain, Delete, Recycle
```
- **`capacity`**: Specifies the storage size.
- **`hostPath`**: This example uses a `hostPath` volume, which mounts a directory from the host node’s filesystem into the PV.
## accessModes
accessModes defines how the PV can be accessed. The common modes are:
- **ReadWriteOnce**: The volume can be mounted as read-write by a single node. Multiple pods running on the same node can still access the PV.
- **ReadOnlyMany**: The volume can be mounted as read-only by many nodes.
- **ReadWriteMany**: The volume can be mounted as read-write by many nodes.
- **ReadWriteOncePod**: The volume can be mounted as read-write by a single pod (Added in Kubernetes v1.29).
## persistentVolumeReclaimPolicy
PersistentVolumeReclaimPolicy determines what happens to the PV when the PVC that is bound to it is deleted:
- **Retain**: Keeps the PV until it is manually deleted.
- **Delete**: Deletes the PV when the PVC is deleted.
- **Recycle**: Deletes the data on the PV and makes it available to be bound to another PVC.
# Persistent Volume Claim (PVC)
A Persistent Volume Claim is a request for storage by a user. It is similar to a Pod in that Pods consume node resources, and PVCs consume PV resources.

Persistent Volume Claim Creation File:
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: myclaim
spec:
  accessModes:
    - ReadWriteOnce  # Access modes: ReadOnlyMany, ReadWriteOnce, ReadWriteMany
  resources:
    requests:
      storage: 500Mi  # Requested storage size
  selector:  # Optional: binds to a PV with specific labels
    matchLabels:
      release: "stable"
```
- **`resources.requests.storage`**: Specifies the amount of storage requested.
- **`selector`**: Can be used to specify criteria for selecting a specific PV, such as labels. This is optional but can ensure that the PVC only binds to a PV that matches certain criteria.
# Using a Persistent Volume Claim in a Pod
Once a PVC is created and bound to a PV, it can be used in a Pod to mount the storage.

Pod Configuration with a Persistent Volume Claim:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  containers:
  - name: myfrontend
    image: nginx
    volumeMounts:
    - mountPath: /var/www/html  # Mount the PVC to this path in the container
      name: mypod
  volumes:
  - name: mypod
    persistentVolumeClaim:
      claimName: myclaim  # Reference to the PVC
```
- **`volumeMounts`**: This section defines where in the container’s filesystem the PVC will be mounted.
- **`volumes.persistentVolumeClaim.claimName`**: Refers to the PVC that was previously created.