---
title: 'Helm Charts'
draft: false
weight: 40
series: ["Helm"]
series_order: 40
---
Searching for a helm chart, deploying a helm chart and deleting a helm release can all be done in a couple of simple steps.

1. **Search for a Chart** - Look up a Helm chart online or use the following command to search for a chart from the Helm Hub:
```sh
helm search hub <chart-name>
```
2. **Add the Repository** - Add the repository containing the chart to your local Helm setup:
```sh
helm repo add <repo-name> <repo-url>
```
- This command adds the repository to your local Helm configuration, allowing Helm to locate and retrieve charts from it.

4. **Deploy the Application** - Install the chart to deploy the application in your Kubernetes cluster:
```sh
helm install <release-name> <repo-name>/<chart-name>
```
- This command installs the chart and creates a release, which is a specific instance of the chart deployed to your cluster.

5. **List All Releases** - To see all existing releases, use:
```sh
helm list
```
- This lists all the Helm releases that are currently deployed in your Kubernetes cluster in the current namespace.

6. **Uninstall the Application** - To uninstall and remove a deployed application:
```sh
helm uninstall <release-name>
```
- This command deletes the release and all Kubernetes resources associated with it.

Since repository information is stored locally, it may become outdated if the remote repository changes. Update the local repo information with:
```sh
helm repo update
```