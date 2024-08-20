---
title: 'What is Helm'
draft: false
weight: 10
series: ["Helm"]
series_order: 10
---
Helm is a package manager for Kubernetes that addresses the challenges of managing complex applications. Kubernetes treats each component of an application (like deployments, services, PVs, PVCs) as separate entities, requiring individual YAML files or one large YAML file to manage them. This approach can be tedious and error-prone, especially when making changes or deleting resources.

Helm streamlines this process by managing all resources associated with an application as a single unit. It offers several key features:
- **Centralized Configuration**: Helm provides a central `values.yaml` file to specify values for different objects, simplifying configuration management.
- **Easy Upgrades**: You can upgrade your application with a single command (`helm upgrade wordpress`), ensuring consistency across all components.
- **Rollback Capabilities**: If something goes wrong, you can roll back changes with one command (`helm rollback wordpress`), minimizing downtime and errors.
- **Simple Uninstallation**: Uninstalling an application is as easy as running `helm uninstall wordpress`, which removes all associated resources in one go.

These features make Helm an essential tool for managing Kubernetes applications efficiently.