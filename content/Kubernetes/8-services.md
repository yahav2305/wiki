---
title: 'Services'
draft: false
---

Services are essential components in Kubernetes that enable communication between pods and provide a mechanism to expose applications to external users. They act as an abstraction layer, decoupling pods from network details and facilitating service discovery within the cluster.

Here's a breakdown of the three primary service types in Kubernetes:
## NodePort
**Functionality:** Exposes a service externally by assigning a port (NodePort) on each node in the cluster. This allows traffic from outside the cluster to reach the service on any node's IP address using the allocated NodePort.
**Use Case:** Suitable when you need to access your application from the internet but don't require a full-fledged external load balancer.
### Creation YAML

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  type: NodePort
  selector:
    app: MyApp  # Service targets pods with label `app: MyApp`
  ports:
    - port: 80      # Service port to receive requests
      targetPort: 80  # Target port on pods to forward requests
      nodePort: 30007  # NodePort for external access (30000-32767 range)
```

**Explanation:**
- `selector` defines which pods the service routes traffic to based on pod labels.
- `ports` defines the service port (where traffic arrives) and the target port on pods (where traffic is forwarded).
- `nodePort` is the externally accessible port on each node in the cluster.
## ClusterIP
**Functionality:** Creates a virtual IP address (ClusterIP) accessible only within the cluster. Pods can use this service IP to communicate with each other.
**Use Case:** Ideal for internal communication between services or pods within the cluster.
### Creation YAML

```yaml
apiVersion: v1
kind: Service
metadata:
  name: back-end
spec:
  type: ClusterIP  # ClusterIP is the default type
  ports:
    - targetPort: 80  # Target port on pods to forward requests
      port: 80        # Service port to receive requests
  selector:
    app: myapp
    type: back-end  # Service targets pods with labels `app: myapp` and `type: back-end`
```

**Explanation:**
- `type: ClusterIP` explicitly defines a ClusterIP service.
- Similar to NodePort, `ports` defines service and target ports.
- `selector` uses labels to match pods managed by the service.
## LoadBalancer
Some cloud providers support external load balancers

### Creation YAML

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  selector:
    app: MyApp
  ports:
    - protocol: TCP
      port: 80
      targetPort: 9376
  clusterIP: 10.0.171.239
  type: LoadBalancer
status:
  loadBalancer:
    ingress:
    - ip: 192.0.2.127
```

Traffic from the external load balancer is directed at the backend Pods. The cloud provider decides how it is load balanced.