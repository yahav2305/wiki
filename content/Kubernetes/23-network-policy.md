---
title: Network Policy
draft: false
weight: 23
series:
  - Kubernetes
series_order: 23
---
In Kubernetes, network policies are used to control the flow of traffic between resources within the cluster. By default, Kubernetes allows traffic to and from all resources, but network policies can be used to enforce restrictions and ensure better security.
# Key Concepts
- **Network Policies**: Define how groups of pods are allowed to communicate with each other and other network endpoints.
- **Ingress**: Rules that define incoming traffic to a pod.
- **Egress**: Rules that define outgoing traffic from a pod.
- **Selectors**: Used to apply network policies to specific pods based on labels, namespaces, or IP addresses.
# Pod-Label Network Policy
## Ingress Example
This network policy only allows traffic to a database pod (`role: db`) from a specific pod (`name: api-pod`) on port 3306.
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: db-policy-in
spec:
  podSelector:
    matchLabels:
      role: db
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          name: api-pod
    ports:
    - protocol: TCP
      port: 3306
```
## Egress Example
This network policy only allows traffic from a database pod (`role: db`) to a specific pod (`name: api-pod`) on port 3306.
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: db-policy-out
spec:
  podSelector:
    matchLabels:
      role: db
  policyTypes:
  - Egress
  egress:
  - to:
    - podSelector:
        matchLabels:
          name: api-pod
    ports:
    - protocol: TCP
      port: 3306
```
# Namespaced Network Policy
## Ingress Example
This policy allows traffic to an `api-pod` only from pods in a namespace labeled `name: prod`.
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: namespace-policy-in
spec:
  podSelector:
    matchLabels:
      name: api-pod
  policyTypes:
  - Ingress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          name: prod
```
## Egress Example
This policy allows traffic from an `api-pod` to any pod in a namespace labeled `name: prod`.
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: namespace-policy-out
spec:
  podSelector:
    matchLabels:
      name: api-pod
  policyTypes:
  - Egress
  egress:
  - to:
    - namespaceSelector:
        matchLabels:
          name: prod
```
# IP-Based Network Policy
## Ingress Example
This policy allows traffic to an `api-pod` only from the IP range `192.168.5.10/32`.
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: ip-policy-in
spec:
  podSelector:
    matchLabels:
      name: api-pod
  policyTypes:
  - Ingress
  ingress:
  - from:
    - ipBlock:
        cidr: 192.168.5.10/32
```
## Egress Example
This policy allows traffic from an `api-pod` only to the IP range `192.168.5.10/32`.
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: ip-policy-out
spec:
  podSelector:
    matchLabels:
      name: api-pod
  policyTypes:
  - Egress
  egress:
  - to:
    - ipBlock:
        cidr: 192.168.5.10/32
```
# Combining Selectors
You can combine selectors to create more complex rules. The following example allows traffic to an `api-pod` from either:
- Pods with the label `name: api-pod` in the namespace labeled `name: prod`.
- The IP range `192.168.5.10/32`.
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: combined-policy-in
spec:
  podSelector:
    matchLabels:
      name: api-pod
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          name: api-pod
      namespaceSelector:
        matchLabels:
          name: prod
    - ipBlock:
        cidr: 192.168.5.10/32
```