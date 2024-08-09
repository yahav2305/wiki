---
title: Labels, Selectors & Annotations
draft: false
weight: 21
series:
  - Kubernetes
series_order: 21
---
In Kubernetes, labels are key-value pairs attached to objects for identifying and organizing them, selectors are queries used to filter objects based on their labels, and annotations are key-value pairs used to store non-identifying metadata.
- **Labels** are used for identifying and organizing resources.
- **Selectors** are queries used to filter resources based on their labels.
- **Annotations** are used to store non-identifying metadata about resources.
# Labels
**Labels** are key-value pairs attached to objects such as pods, nodes, and services. They are used to identify and organize resources, and to denote relationships between resources.
You can attach labels to resources in the resource creation file under `metadata.labels`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    app: webapp
    function: front-end
    <key-name>: <key-value>
spec:
  containers:
  - name: nginx
    image: nginx
```
# Selectors
**Selectors** are used to filter resources based on their labels. They enable you to select and manage groups of objects dynamically.
To filter and show resources with a specific label, use the `--selector` option with `kubectl`:

| Command                                                     | Description                                                             |
| ----------------------------------------------------------- | ----------------------------------------------------------------------- |
| `kubectl get <resource> --selector <key-name>=<value-name>` | Show the specified resource with the specified key name and value name. |

For example, to get all pods with the label `app=webapp`:

```sh
kubectl get pods --selector app=webapp
```
# Annotations
**Annotations** are key-value pairs used to store non-identifying metadata about resources. They can be used to document resources with information such as the name, version, ID, and contact information.
You can attach annotations to resources in the resource creation file under `metadata.annotations`:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  annotations:
    app: webapp
    function: front-end
    <key-name>: <key-value>
spec:
  containers:
  - name: nginx
    image: nginx:1.14.2
```