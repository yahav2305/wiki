---
title: Taints and Tolerations
draft: false
weight: 15
series:
  - Kubernetes
series_order: 15
---
Taints are used when you want certain pods to only use certain nodes.
Only pods with a toleration that fits the taint of a matching node can use the node.
# Tolerations
Adding toleration to a pod (note `tolerations` under `spec`):
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: nginx
  tolerations:
  - key: "example-key"
    operator: "Equal"
    value: "example-value"
    effect: "NoSchedule"
```
- The key and value must match the key and value in the node.
# Taint Effects
Taint effect sets what will happen if a pod can't use a node with a taint on it:
- `NoSchedule`: The pod can't use the node.
- `PreferNoSchedule`: The pod won’t use the node unless there is no other option.
- `NoExecute`: New pods won’t use the node, and pods that are already using the node and don’t have the right toleration will stop using the node.
# `kubectl` Commands

| Command | Description |
| --- | --- |
| `kubectl taint nodes <node-name> <key>=<value>:<taint-effect>` | Applies a taint with the specified key and value to the specified node with the specified taint effect. |

## Notes
- A taint doesn’t force a certain pod to use a certain node, but it does force a node to only accept certain pods. Because of that, there is a chance that a certain node will be empty because there are no pods that can use it. For this case, node affinity should be used.
- By default, the master node has a taint on it so it won’t be able to accept pods.