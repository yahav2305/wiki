---
title: Storage Class
draft: false
weight: 27
series:
  - Kubernetes
series_order: 27
---
**Storage Classes** in Kubernetes allow administrators to define different types or "classes" of storage that can be dynamically provisioned based on the needs of the Persistent Volume Claims (PVCs).
This system provides flexibility in managing storage by allowing the automatic creation of Persistent Volumes (PVs) when a PVC is created.
# Example Use Case
Suppose you have a Kubernetes cluster running in Google Cloud, and you need to provide persistent storage for your applications. By defining a `StorageClass` with `kubernetes.io/gce-pd` as the provisioner, you enable dynamic provisioning. When developers create PVCs that reference this StorageClass, Kubernetes automatically provisions the necessary Google Persistent Disks and binds them to the PVCs, simplifying the process.
# Static vs. Dynamic Provisioning
- **Static Provisioning**: The administrator manually creates PVs, and users create PVCs that bind to those existing PVs.
- **Dynamic Provisioning**: PVs are automatically created by Kubernetes based on the StorageClass specified in the PVC. This method is more efficient and scalable, especially in cloud environments.
# Storage Class
A **StorageClass** object defines the provisioner, parameters, and reclaim policy that Kubernetes uses to create and manage PVs dynamically. It abstracts the underlying storage to allow for different storage backends, such as cloud storage, network storage, or local storage.
## Storage Class Creation File
```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: standard
provisioner: kubernetes.io/gce-pd  # Google Persistent Disk provisioner
```

Key Elements:
- **`provisioner`**: Specifies the provisioner that will be used to create the PVs. In this example, `kubernetes.io/gce-pd` refers to Google Persistent Disk, which is specific to Google Cloud. Other common provisioners include:
	- `kubernetes.io/aws-ebs` for AWS Elastic Block Store
	- `kubernetes.io/azure-disk` for Azure Disk
	- `kubernetes.io/cinder` for OpenStack Cinder
	- `kubernetes.io/no-provisioner` for manual provisioning
## Default Storage Class
When a PVC does not specify a storage class, the default storage class is used.
We can set a storage class to be the default one by adding the annotation `storageclass.kubernetes.io/is-default-class: true` to the storage class.
This can be set using the following command:
```sh
kubectl patch storageclass <storage-class-name> -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
```
We can set a storage class to not be the default one by running the following command:
```sh
kubectl patch storageclass <storage-class-name> -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'
```
# Persistent Volume Claim Using Storage Class
You can specify a StorageClass in a PVC to dynamically provision a PV that meets the requirements specified in the PVC.
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-pvc
  namespace: mynamespace
spec:
  storageClassName: "standard"  # Reference to the StorageClass named 'standard'
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```
Key Elements:
- **`storageClassName`**: References the name of the StorageClass that should be used to dynamically provision the PV. If `""` (empty string) is specified, the default StorageClass is used.
- **`accessModes`** and **`resources.requests.storage`**: These specify the required access mode and storage size, as in a regular PVC.