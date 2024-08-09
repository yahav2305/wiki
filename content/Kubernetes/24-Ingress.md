---
title: Ingress
draft: false
weight: 24
series:
  - Kubernetes
series_order: 24
---
An **Ingress** is a Kubernetes API object that manages external access to services within a cluster, typically over HTTP and HTTPS. It provides a way to route external traffic to services based on rules you define, and can include features like load balancing, SSL termination, and name-based virtual hosting.
# Key Concepts
- **Ingress Controller**: A controller that fulfills the Ingress resource, handling the traffic routing based on the rules defined in the Ingress resource.
- **Ingress Resource**: Defines how the external traffic should be routed to the services inside the Kubernetes cluster.
# Ingress Controllers
An Ingress resource requires an Ingress controller to function. Without a controller, the Ingress resource has no effect. Some common Ingress controllers include:
- **GCE**: Google Cloud Platform's Ingress controller.
- **NGINX**: A popular open-source web server that also functions as an Ingress controller.
- **Contour**: An Ingress controller for Kubernetes that provides advanced load balancing features.
- **HAProxy**: An open-source load balancer.
- **Traefik**: A modern, cloud-native Ingress controller with built-in support for microservices.
- **Istio**: A service mesh that includes an Ingress controller with additional traffic management features.
# Creating an Ingress Resource
You can create an Ingress resource using either imperative commands or declarative YAML files.
## Imperative Command
```sh
kubectl create ingress <ingress-name> --rule="host/path=service:port"
```
## Declarative YAML File
A simple Ingress resource directing traffic to a service:
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-wear
spec:
  backend:
    service:
      name: wear-service
      port:
        number: 80
```
# Ingress Rules and Routing
Ingress rules define how traffic should be routed to services based on the domain name and path in the URL.
## Rule and Path
- **Rule**: Set by the domain name.
- **Path**: The part of the URL after the '/' in the domain name.
## Example 1: Single Rule with Multiple Paths
This example routes traffic based on the path:
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-wear
spec:
  ingressClassName: nginx
  # When we don't specify a domain, the traffic will come from any domain
  rules:
  - http:
      paths:
      # Traffic from /wear will go to wear-service
      - path: /wear
        pathType: Prefix
        backend:
          service:
            name: wear-service
            port:
              number: 80
      # Traffic from /watch will go to watch-service
      - path: /watch
        pathType: Prefix
        backend:
          service:
            name: watch-service
            port:
              number: 80
```
## Example 2: Multiple Rules with One Path Each
This example uses different domain names to route traffic:
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-wear-watch
spec:
  rules:
  # All traffic from wear.my-online-store.com will go to wear-service
  - host: "wear.my-online-store.com"
    http:
      paths:
      - pathType: Prefix
        path: "/"
        backend:
          service:
            name: wear-service
            port:
              number: 80
  # All traffic from watch.my-online-store.com will go to watch-service
  - host: "watch.my-online-store.com"
    http:
      paths:
      - pathType: Prefix
        path: "/"
        backend:
          service:
            name: watch-service
            port:
              number: 80
```
# Notes
- **Default Backend**: If traffic doesn't match any of the defined rules, it is routed to a default backend service. It's recommended to configure this default backend to serve a 404 page to handle unmatched requests.
- Use `kubectl describe ingress <ingress-name>` to inspect the default service and routing details.