---
title: 'Namespaces'
draft: false
weight: 9
series: ["Kubernetes"]
series_order: 9
---

Separates objects for security and minimizes human error.
- **Default namespace**: Called `default`.
# Same namespace communication
Objects in the same namespace can call each other with their hostname, for example:
```sql
mysql.connect(”db-service”)
```
# Different namespaces communication
Objects in different namespaces can call each other with their full name, for example:
```sql
mysql.connect("db-service.dev.svc.cluster.local")
```
Syntax for full name:
```
[service-name].[namespace].svc.cluster.local
```
# `kubectl` Namespace Commands
| Command                                                                                     | Description                                                                          |
| ------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------ |
| `kubectl get <resource>`                                                                    | Displays resource in current namespace                                               |
| `kubectl get <resource> --namespace=<namespace>`                                            | Displays resource in specified namespace                                             |
| `kubectl get <resource> -A`                                                                 | Displays resource in all namespaces                                                  |
| `kubectl get <resource> --all-namespaces`                                                   | Displays resource in all namespaces                                                  |
| `kubectl create -f resource-definition.yaml`                                                | Creates resource in current namespace                                                |
| `kubectl create -f resource-definition.yaml --namespace=<namespace>`                        | Creates resource in specified namespace                                              |
| `kubectl create namespace <namespace-name>`                                                 | Create a namespace                                                                   |

# Creating a Namespace Using a Definition File
```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: dev
```
# Specifying the Namespace in an Object Definition File
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  namespace: dev
spec:
  containers:
  - name: nginx
    image: nginx:1.14.2
    ports:
    - containerPort: 80
```
# Resource Quota for a namespace
We can set a resource quota for a namespace, which limits the quantity of objects that can be created in a namespace by type, as well as the total amount of compute resources that may be consumed by resources in that namespace.
```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-quota
  namespace: dev
spec:
  hard:
    pods: "10"
    requests.cpu: "4"
    requests.memory: 5Gi
    limits.cpu: "10"
    limits.memory: 10Gi
```