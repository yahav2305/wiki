---
title: Node Affinity
draft: false
weight: 17
series:
  - Kubernetes
series_order: 17
---
Node affinity ensures a specific pod will use a specific node with more customizability compared to node selectors.
It works by using labels.
# Node Affinity in Pod Creation File
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: nginx
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: disktype
            operator: In
            values:
            - ssd
```
# Operator Values
- **In**: True if the value is in the specified key in the node.
- **NotIn**: True if the value is not in the specified key in the node.
- **Exists**: True if the key exists in the node.
- **DoesNotExist**: True if no label with this key exists on the node.
# Node Affinity Values
- **requiredDuringSchedulingIgnoredDuringExecution**: The pod won’t use the node if the conditions don’t fit.
- **preferredDuringSchedulingIgnoredDuringExecution**: The pod will try not to use the node if the conditions don’t fit, but will use the node if there is no other option that works.
- When a pod is already using a node, changing the label won’t affect it because of the `IgnoredDuringExecution` part.