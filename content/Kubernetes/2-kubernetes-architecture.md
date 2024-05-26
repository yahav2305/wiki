---
title: 'Kubernetes Architecture'
draft: false
weight: 2
series: ["Kubernetes"]
series_order: 2
---

A Kubernetes cluster consists of worker machines (nodes) running containerized applications and a control plane managing them.

# Control Plane Components

- **kube-apiserver:** The front-end for Kubernetes API, scalable horizontally.
- **etcd:** A highly available key value store storing cluster data.
- **kube-scheduler:** Assigns Pods to nodes based on various factors.
- **kube-controller-manager:** Runs multiple controllers for node management, jobs, etc.
- **cloud-controller-manager (optional):** Integrates with cloud provider APIs.

# Node Components

- **kubelet:** Manages Pods and ensures containers are running on each node.
- **kube-proxy:** Implements network rules and enables communication to Pods.
- **Container runtime:** Executes and manages container lifecycles (e.g., containerd, CRI-O).

# Addons

- Additional features deployed as Kubernetes resources in the `kube-system` namespace.
- Examples: DNS server, web UI (dashboard), resource monitoring, cluster-level logging, network plugins.