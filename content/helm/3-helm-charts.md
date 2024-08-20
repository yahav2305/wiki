---
title: 'Helm Charts'
draft: false
weight: 30
series: ["Helm"]
series_order: 30
---
Helm charts are packaged Kubernetes applications that simplify the deployment and management of applications within a Kubernetes cluster. They provide a way to bundle all the necessary Kubernetes resources into a single package, making it easier to deploy, upgrade, and manage applications.
# Helm Chart Structure
A typical Helm chart directory structure includes:
- **`templates/` (directory):** Contains Kubernetes manifest files (in YAML format) that define the resources to be created. These files use Go templating to dynamically generate the manifests based on the values provided.
- **`values.yaml` (file):** Contains default configuration values for the chart. Users can override these values during chart installation or upgrades.
- **`Chart.yaml` (file):** Contains metadata about the chart.
- **`LICENSE` (file):** (Optional) License information for the chart.
- **`README.md` (file):** (Optional) Documentation for the chart, providing information on usage, configuration, and installation.
- **`charts/` (directory):** (Optional) Contains dependent charts that are required by the main chart. This directory is used to package dependencies.
# `values.yaml`
- **Purpose:** This file provides default configuration values for the templates within the chart. Users can override these values when installing or upgrading the chart to customize the deployment.
- **Usage:** Values from `values.yaml` are used in the templates to generate Kubernetes manifest files. This allows you to parameterize configurations without modifying the templates themselves.
# `Chart.yaml`
This file contains metadata about the Helm chart. Here's an explanation of its fields:
```yaml
apiVersion: v2
appVersion: 5.8.1
version: 12.1.27
name: wordpress
description: Web publishing platform for building blogs and websites.
type: application
dependencies:
  - condition: mariadb.enabled
    name: mariadb
    repository: http://charts.bitnami.com/bitnami
    version: 9.x.x
keywords:
  - application
  - blog
  - wordpress
maintainers:
  - email: containers@bitnami.com
    name: Bitnami
home: https://github.com/bitnami/charts/tree/main/bitnami/mariadb
icon: https://bitnami.com/assets/stacks/mariadb/img/mariadb-stack-220x234.png
```
Fields Explained:
- **apiVersion:** Indicates the version of the Helm chart API. Helm 3 charts use `v2`, whereas Helm 2 charts use `v1` or may omit this field.
- **appVersion:** Specifies the version of the application contained within the chart.
- **version:** The version of the Helm chart itself. This helps track changes to the chart independently of the application version.
- **name:** The name of the chart.
- **description:** A brief description of what the chart does.
- **type:** Specifies whether the chart is an `application` (default) or a `library`. Library charts provide reusable templates for other charts.
- **dependencies:** Lists other charts that this chart depends on. For example, the WordPress chart may depend on a MariaDB chart.
- **keywords:** Tags that help in searching and identifying the chart in repositories.
- **maintainers:** Contact information for the people maintaining the chart.
- **home:** (Optional) URL to the homepage of the project.
- **icon:** (Optional) URL to an icon representing the chart or application.