---
title: 'Helm Components'
draft: false
weight: 20
series: ["Helm"]
series_order: 20
---
Helm has a structured approach that makes it a powerful tool for managing complex Kubernetes applications efficiently:
- **Helm CLI:** A command-line tool used for managing Helm charts and their deployments, allowing you to perform actions like installing, upgrading, rolling back, and uninstalling applications.
- **Charts:** Packages of pre-configured Kubernetes resources that include all necessary files for deploying an application or service in a Kubernetes cluster.
- **Release:** The deployment of a Helm chart in a Kubernetes cluster. Each release represents a unique instance of an application.
- **Revision:** A versioned snapshot of a release, created each time a change is made. Revisions allow you to track changes and roll back to previous states if needed.
- **Chart Repository:** A storage location for Helm charts, where you can download and deploy charts to your Kubernetes cluster.
- **Metadata:** Information stored in the Kubernetes cluster (as secrets) that tracks the state of Helm releases, including revisions, configurations, and other details necessary for managing deployments.