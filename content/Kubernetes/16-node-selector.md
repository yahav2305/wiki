---
title: Node Selector
draft: false
weight: 16
series:
  - Kubernetes
series_order: 16
---
To ensure a specific pod uses a specific node, use node selectors. This method allows pods to use nodes with certain labels.
# `kubectl` Commands

| Command                                                     | Description                                               |
| ----------------------------------------------------------- | --------------------------------------------------------- |
| `kubectl label nodes <node-name> <label-key>=<label-value>` | Sets the specified node with the specified key and value. |
# NodeSelector in Resource Definition File
Set acceptable node labels in the pod definition file (see `nodeSelector` under `spec`):
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: nginx
  nodeSelector:
    size: Large
```
## Notes
- To define that a certain pod won’t be able to use a specific node or that a certain pod will be able to use multiple nodes with multiple labels, use node affinity instead of node selectors.