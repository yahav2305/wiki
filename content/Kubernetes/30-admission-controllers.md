---
title: Admission Controllers
draft: false
weight: 30
series:
  - Kubernetes
series_order: 30
---
Admission controllers in Kubernetes are pieces of code that intercept API requests to the Kubernetes API server before the requested object is persisted, but after the request has been authenticated and authorized. These controllers enforce certain policies, such as limiting or modifying requests for creating, deleting, or modifying objects, or connecting to a proxy. However, they do not limit requests that only involve reading objects.
# Key Admission Controllers
1. **AlwaysPullImages**:
   - Ensures that Kubernetes always pulls container images when creating a pod, enforcing the use of the latest image.
2. **DefaultStorageClass**:
   - Automatically assigns a default storage class to PersistentVolumeClaims (PVCs) that don’t specify one, facilitating storage provisioning.
3. **EventRateLimit**:
   - Controls the rate of events that the Kubernetes API server can process, helping to protect the server from being overwhelmed.
4. **NameSpaceExists** (Deprecated):
   - Ensures that resources are only created in namespaces that already exist. For example, if you try to create a pod in a non-existent namespace (`kubectl run nginx --image nginx --namespace blue`), it will return an error: `Error from server (NotFound): namespace “blue” not found.`
5. **NameSpaceAutoProvision** (Deprecated):
   - Automatically creates a namespace if a request is made to create resources in a namespace that doesn’t exist.
6. **NameSpaceLifeCycle**:
   - This is the recommended replacement for both `NameSpaceExists` and `NameSpaceAutoProvision`. It handles the lifecycle of namespaces, such as ensuring that resources aren’t created in namespaces that are terminating.
# Viewing and Configuring Admission Controllers
You can view the active admission controllers by running the following command:
```sh
kube-apiserver -h | grep enable-admission-plugins
```

To enable or disable admission controllers, you need to modify the API server configuration file at `/etc/kubernetes/manifests/kube-apiserver.yaml`. Below is an example configuration:
```yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  name: kube-apiserver
  namespace: kube-system
spec:
  containers:
  - command:
    - kube-apiserver
    - --authorization-mode=Node,RBAC
    - --advertise-address=172.17.0.107 
    - --allow-privileged=true
    - --enable-bootstrap-token-auth=true
    - --enable-admission-plugins=NodeRestriction,NamespaceAutoProvision
    - --disable-admission-plugins=DefaultStorageClass
    image: k8s.gcr.io/kube-apiserver-amd64:v1.11.3
    name: kube-apiserver
```
In this configuration:
- **Enabling** an admission controller: Add it to the `--enable-admission-plugins` flag.
- **Disabling** an admission controller: Add it to the `--disable-admission-plugins` flag.

Admission controllers can be enabled by the following command:
```sh
kube-apiserver --enable-admission-plugins=<admission-controller-name-1>,<admission-controller-name-2>,...
```

Admission controllers can be disabled by the following command:
```sh
kube-apiserver --disable-admission-plugins=<admission-controller-name-1>,<admission-controller-name-2>,...
```
# Validating and Mutating Admission Controllers
Kubernetes admission controllers are divided into two main types: **mutating** and **validating**. Both types play a crucial role in processing requests to the Kubernetes API server, ensuring that these requests conform to the cluster's policies and standards.
## Types of Admission Controllers
**Mutating Admission Controllers:** Mutating admission controllers can modify or alter the objects related to the request they admit. They can automatically add, remove, or modify fields in the object specifications before they are persisted.
- **Example**:
  - **DefaultStorageClass**: Automatically assigns a storage class to any new PersistentVolumeClaim (PVC) that doesn’t specify one, ensuring a default storage option is used.
**Validating Admission Controllers:** Validating admission controllers either accept or reject requests based on whether the requests meet certain conditions or policies. They do not modify the requests but ensure that the requests are valid according to predefined rules.
- **Example**:
  - **NameSpaceExists**: Ensures that the request is accepted only if the specified namespace already exists. If not, it rejects the request.
## Order of Execution
1. **Mutating Admission Controllers** are executed first. This allows them to make any necessary changes to the object in the request before validation.
2. **Validating Admission Controllers** are executed afterward. They assess the final, potentially modified, object to determine if it meets all necessary conditions.
## Custom Admission Controllers
Kubernetes also allows the creation of custom mutating and/or validating admission controllers to enforce specific policies or make custom modifications to requests. These custom controllers can be used to implement organization-specific rules, security policies, or operational standards.
- **Custom Mutating Admission Controllers**: Can be used to automatically modify incoming requests to meet custom requirements, such as injecting sidecars or setting specific annotations.
- **Custom Validating Admission Controllers**: Can enforce specific validation rules, such as ensuring that resources comply with naming conventions, security policies, or resource quotas.