# wiki

## How to format pages?
In order for hugo to play nicely with markdown pages, some rules need to be kept in mind.

### Subject
- Each subject must be in each own folder.
- The subject folder can be either lowercase or uppercase, but when accessing it the subject folder name will be converted to lowercase.
- Each subject will have one `_index.md` file with the following front matter:
  ```yaml
  ---
  title: '<SubjectName>'
  draft: false
  ---
  ```
  where **SubjectName** is the name of the subject in capital case.

### Article
- Each article name will be in lowercase with dashes between words and end in `.md`.
- Each article must start with the front matter:
  ```yaml
  ---
  title: '<title>'
  draft: <true|false>
  weight: <weightNum>
  series: ["<seriesName>"]
  series_order: <seriesOrder>
  ---
  ```
  - **title** is the name of the file in capital case with spaces between words instead of dashes.
  - **draft** can be `true` or `false` depending on if the article should be displayed in the website.
  - **weight** is the order of the article. This will alter the place of the article in the subject list page.
  - **seriesName** is the name of the series in capital case, which is the name of the subject. This must be the same between all articles in the same subject, and must not be used in articles outside of the subject.
  - **seriesOrder** is the place of the article in the series. 1 means that the article will be first, 2 is second, etc.
- After the front matter, each article must have the article content itself.

# Infrastructure for my wiki

This document details the infrastructure components used to deploy and manage my wiki. 

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

### Istio Service Mesh Monitoring

[Kiali](https://kiali.io/) offers real-time monitoring capabilities for the Istio service mesh. The Kiali operator facilitates its deployment, while secure access to the Kiali dashboard is achieved via the following command:

```
kubectl port-forward svc/kiali 20001:20001 -n istio-system
```

This configuration ensures secure access to the Kiali dashboard within the current single-user management context.

Absolutely, here's the improved section on Loki and Prometheus for your README:

### Log Aggregation with Loki

[Grafana Loki](https://grafana.com/oss/loki/) serves as the central repository for application and infrastructure logs generated across the Kubernetes cluster. Loki's suitability for semi-structured and unstructured data, prevalent in modern log formats, makes it a preferable choice over alternatives like Elasticsearch.

Logs from various applications running within the cluster are forwarded to the following endpoint:

```
http://loki-gateway.loki.svc.cluster.local/loki/api/v1/push
```

For integration with Grafana for visualization purposes, Loki is configured as a data source using the following URL:

```
http://loki-gateway.loki.svc.cluster.local/
```

### Metrics Collection with Prometheus

[Prometheus](https://prometheus.io/) is responsible for gathering and storing metrics from all cluster components, including resource utilization of containers and nodes. 

To expedite deployment, Prometheus was installed as a Helm chart, incorporating a node collector and alert manager. While this approach streamlines initial setup, a future migration to the Prometheus operator is envisioned. The operator offers finer-grained control and potentially enhanced scalability.

Prometheus UI is accessible using the following commands:
```
export POD_NAME=$(kubectl get pods --namespace prometheus -l "app.kubernetes.io/name=prometheus,app.kubernetes.io/instance=prometheus" -o jsonpath="{.items[0].metadata.name}")
kubectl --namespace prometheus port-forward $POD_NAME 9090
```
And then entering http://localhost:9090/ in the web browser.