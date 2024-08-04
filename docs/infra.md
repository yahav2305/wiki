# Infrastructure for my wiki

This document details the infrastructure components used to deploy and manage my website.

## Kubernetes Platform

A single [NetCup](https://www.netcup.eu/) virtual machine serves as the foundation for the Kubernetes cluster (version 1.30). This cost-effective solution caters to current budgetary constraints. Ideally, a highly available (HA) configuration with three dedicated control plane nodes and multiple worker nodes would be implemented for optimal performance and redundancy.

The `k8s-install.sh` script within the `kubernetes` directory provides detailed instructions on the Kubernetes deployment process using the kubeadm tool.

## Resource Management

A centralized Bash script located in the `helm` directory streamlines the deployment of all Kubernetes resources, including Helm charts, operators, and other configurations.

* Helm charts leverage separate `values.yaml` files stored within their respective directories inside the `values` subfolder.
* Custom or standard resources (specified in YAML files) are located in the `resources` directory inside the `helm` subfolder.

To initiate the deployment of Kubernetes resources and Helm charts, I execute the `init.sh` script directly on the server hosting the Kubernetes cluster within the `helm` directory.

### Network Connectivity

[Calico](https://www.tigera.io/project-calico/) serves as the selected Container Network Interface (CNI) for the Kubernetes cluster. Its comprehensive feature set coupled with a straightforward installation process made it the optimal choice over Weave or Flannel.

### Service Mesh Security

[Istio](https://istio.io/latest/) provides a service mesh with mutual TLS (mTLS) encryption for secure communication between pods. This safeguards against potential eavesdropping attempts on internal cluster network traffic. Istio efficiently manages its own certificates, minimizing operational overhead.

## Ingress Management with Ingress Nginx

The [Ingress Nginx](https://github.com/kubernetes/ingress-nginx) controller is currently utilized for managing ingress traffic within the cluster. This choice was driven by its:

* **Simplicity:** Easy installation and configuration make Ingress Nginx a user-friendly option for basic ingress routing needs.

However, future plans involve transitioning to the [Istio Ingress Gateway](https://istio.io/latest/docs/tasks/traffic-management/ingress/ingress-control/). This shift aligns with the long-term goal of implementing a comprehensive Istio service mesh for robust traffic management throughout the infrastructure.

By leveraging Istio's Ingress Gateway, I aim to achieve:

* **Unified Service Mesh:** Seamless integration with the existing Istio service mesh, enhancing consistency and control.
* **Advanced Traffic Management:** Utilizing Istio's advanced capabilities for sophisticated traffic routing and security policies.

This migration will further strengthen the infrastructure's ability to handle complex routing scenarios while maintaining a cohesive service mesh architecture.

In order to utilize ingress-nginx, I specify `nginx` in spec.ingressClassName in an ingress object.

### Log Aggregation with Loki

[Grafana Loki](https://grafana.com/oss/loki/) serves as the central repository for application and infrastructure logs generated across the Kubernetes cluster. Loki's suitability for semi-structured and unstructured data, prevalent in modern log formats, makes it a preferable choice over alternatives like Elasticsearch.

Logs from various applications running within the cluster are forwarded to the following endpoint:

```
http://loki-gateway.monitoring.svc.cluster.local/loki/api/v1/push
```

For integration with Grafana for visualization purposes, Loki is configured as a data source using the following URL:

```
http://loki-gateway.monitoring.svc.cluster.local/
```

### Metrics Collection with Prometheus

[Prometheus](https://prometheus.io/) is responsible for gathering and storing metrics from all cluster components, including resource utilization of containers and nodes. 

To expedite deployment, Prometheus was installed as a Helm chart, incorporating a node collector and alert manager. While this approach streamlines initial setup, a future migration to the Prometheus operator is envisioned. The operator offers finer-grained control and potentially enhanced scalability.

Prometheus UI is accessible using the following commands:
```
export POD_NAME=$(kubectl get pods --namespace monitoring -l "app.kubernetes.io/name=prometheus,app.kubernetes.io/instance=prometheus" -o jsonpath="{.items[0].metadata.name}")
kubectl --namespace monitoring port-forward $POD_NAME 9090
```
And then entering http://localhost:9090/ in the web browser.

Alert manager UI is accessible using the following commands:
```
export POD_NAME=$(kubectl get pods --namespace monitoring -l "app.kubernetes.io/name=alertmanager,app.kubernetes.io/instance=prometheus" -o jsonpath="{.items[0].metadata.name}")
kubectl --namespace monitoring port-forward $POD_NAME 9093
```
And then entering http://localhost:9093/ in the web browser.

PushGateWay UI is accessible using the following commands:
```
export POD_NAME=$(kubectl get pods --namespace monitoring -l "app.kubernetes.io/instance=prometheus,app.kubernetes.io/name=prometheus-pushgateway" -o jsonpath="{.items[0].metadata.name}")
kubectl --namespace monitoring port-forward $POD_NAME 9091
```
And then entering http://localhost:9091/ in the web browser.

### Visualization with Grafana

[Grafana](https://grafana.com/) serves as the visualization platform for the monitoring stack, providing a user-friendly interface to explore metrics and logs. Its key advantages in this context include:

* **Ease of Use:**  An intuitive interface lowers the barrier to entry for users of all technical backgrounds.
* **Loki Stack Compatibility:**  Grafana integrates seamlessly with Loki, Prometheus, and Promtail, offering a cohesive monitoring experience for the entire infrastructure.
* **Simplified Deployment:**  Deployment is streamlined through a single Helm chart, minimizing configuration complexity.

This combination of factors makes Grafana an ideal choice for visualizing the wealth of data collected from my Kubernetes environment.

I access the grafana dashboard with the following commands:
```
export POD_NAME=$(kubectl get pods --namespace monitoring -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=grafana" -o jsonpath="{.items[0].metadata.name}")
kubectl --namespace monitoring port-forward $POD_NAME 3000
```

I get the admin password with the following command:
```
kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

### Log Collection with Promtail

[Promtail](https://grafana.com/docs/loki/latest/clients/promtail/) is the agent responsible for collecting and forwarding logs from applications running within the Kubernetes cluster to the central Loki repository. Its selection was driven by several key factors:

* **Native Loki Compatibility:**  Promtail seamlessly integrates with Loki, ensuring efficient log ingestion and storage.
* **Streamlined Deployment:**  A single Helm chart facilitates deployment, eliminating the need for complex configuration management.
* **Kubernetes-Aware Scraping:**  Promtail is pre-configured to scrape logs from Kubernetes clusters, saving time and effort during setup.
* **DaemonSet Scalability:**  Deployment as a DaemonSet ensures automatic log collection from any node added to the cluster, enhancing scalability.

These combined benefits make Promtail an ideal solution for collecting and routing logs within my Kubernetes environment.

### Security Monitoring with Falco

[Falco](https://falco.org/) is a runtime security scanner deployed as a Helm chart that provides real-time threat detection for my Kubernetes cluster.
Falco continuously monitors kernel events to identify potential security events and generate alerts accordingly.

Integrating Falco into my infrastructure offered several advantages:

* **Enhanced Security Posture:**  Real-time monitoring helps identify and mitigate potential security threats before they escalate into major incidents.
* **Actionable Alerts:**  Falco generates alerts for suspicious activity, allowing security teams to take swift action and investigate potential breaches.
* **Helm Chart Deployment:**  The Helm chart simplifies deployment and streamlines configuration management for Falco.

By leveraging Falco's capabilities, I strengthed the security posture of my Kubernetes cluster and proactively addressed potential security threats.

I access the Falco dashboard with the following commands:
```
kubectl port-forward -n falco svc/falco-falcosidekick-ui 2802:2802
```
And then enter `http://localhost:2802` in my browser.

## Continuous Integration and Delivery (CI/CD) with GitHub Actions

This section details the current implementation of our CI/CD pipeline using [GitHub Actions](https://docs.github.com/en/actions). GitHub Actions automates various tasks associated with the development lifecycle, streamlining the process from code commit to deployment.

**Current Workflow:**

* GitHub servers currently host the CI/CD pipeline execution.
* Test execution is triggered for:
    * Pull requests targeting the main branch.
    * New commits directly pushed to the main branch.

**Future Enhancements:**

I acknowledge that testing on every commit is the ideal approach for comprehensive code coverage. However, limitations on free minutes for GitHub-hosted runners necessitate the current configuration.

A planned migration to [ARC](https://github.com/actions/actions-runner-controller) will leverage our Kubernetes cluster for CI/CD execution. This transition will enable:

* **Scalability:** The ability to scale runner capacity based on project needs.
* **Reduced Costs:** Utilizing our own infrastructure for CI/CD reduces reliance on external resources.
* **Improved Efficiency:**  Potentially faster test execution times due to dedicated runner resources.

By migrating to ARC, I aim to achieve continuous testing on every commit, enhancing code quality and overall project stability.