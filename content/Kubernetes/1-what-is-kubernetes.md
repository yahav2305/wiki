---
title: 'What is Kubernetes'
draft: false
---
# Table of Contents

- [What is Kubernetes](#what-is-kubernetes)
	- [Key features](#key-features)
	- [Benefits](#benefits)
	- [What Kubernetes is not](#what-kubernetes-is-not)


# What is Kubernetes
Kubernetes (K8s) is an open-source platform designed to manage containerized applications. It automates deployment, scaling, and operations of containerized workloads, ensuring applications run efficiently and reliably.
## Key features
- **Service discovery & load balancing:** Makes applications accessible and distributes traffic for stability.
- **Storage orchestration:** Automates storage system mounting for deployments.
- **Automated deployments & rollbacks:** Manages desired application states and transitions smoothly between them.
- **Resource management:** Optimizes resource allocation by placing containers efficiently on nodes.
- **Self-healing:** Restarts failed containers, maintains healthy deployments.
- **Secret & configuration management:** Stores sensitive information securely.
- **Scaling:** Scales applications up or down based on needs.
## Benefits
- Efficient resource utilization
- Faster deployments
- Reliable application delivery
- Scalability and elasticity
- Simplified management of containerized workloads
## What Kubernetes is not
- An all-inclusive PaaS solution (focuses on container orchestration, not entire application lifecycle)
- Application builder or deployer (integrates with CI/CD workflows)
- Provider of application-level services (databases, middleware, etc.)
- Dictator of logging, monitoring, or configuration tools
**In essence, Kubernetes provides the building blocks for managing and scaling containerized applications in a flexible and automated way.**