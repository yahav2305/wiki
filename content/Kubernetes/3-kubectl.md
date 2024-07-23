---
title: 'Kubectl'
draft: false
weight: 3
series: ["Kubernetes"]
series_order: 3
---

Kubectl is a command-line tool that allows you to interact with a Kubernetes cluster's control plane through the Kubernetes API.
# Basic Syntax
```shell
kubectl [command] [TYPE] [NAME] [flags]
```
- **command**: The action you want to perform (e.g., create, get, describe, delete).
- **TYPE**: The kind of Kubernetes resource (e.g., pod, deployment, service). Case-insensitive, can be singular, plural, or abbreviated.
- **NAME**: The name of the specific resource (case-sensitive). Omit for details on all resources of that type.
- **flags**: Optional flags to modify command behavior (e.g., `-o` for output format, `--sort-by` for sorting lists).
## Examples
```shell
kubectl get pods  # Get details of all pods
kubectl get pod my-pod  # Get details of pod named "my-pod"
kubectl delete pod old-pod  # Delete pod named "old-pod"
```
## Specifying Multiple Resources
- You can specify multiple resources by type and name or using files containing resource definitions.
- By type and name:
    - Group resources of the same type: `kubectl get pod pod1 pod2 pod3`
    - Specify multiple resource types: `kubectl get pod/pod1 deployment/deployment1`
- Using files:
    - Use YAML files for resource definitions (preferred over JSON for readability).
    - Specify files with `-f` flag: `kubectl get -f deployment.yaml`
# Cluster Access Configuration
Kubectl looks for a configuration file named `config` in `$HOME/.kube` by default. You can specify alternative locations using the `KUBECONFIG` environment variable or the `--kubeconfig` flag.

The configuration file (`kubeconfig`) defines:
- **Clusters:** Information about the cluster to connect to (server address, certificate authority).
- **Users:** User accounts for connecting to the cluster (name, secret token).
- **Contexts:** Links between cluster and user configs, specifying the active context.

Example of a config file:
```yaml
apiVersion: v1
kind: Config
clusters:
- cluster:
    certificate-authority-data: <cluster-ca-data-file-path>
    server: <cluster-api-endpoint>
  name: <cluster-config-name>
contexts:
- context:
    cluster: <cluster-config-name>
    user: <cluster-name-user>
  name: <cluster-contex>
current-context: <current-used-context>
users:
- name: <cluster-name-user>
  user:
    token: <secret-user-token>
```

Use `kubectl config use-context <context-name>` to set the active context.
## Output options
### Formatting output

Default output is plain text.
Use `-o` or `--output` flag to specify a different format (e.g., json, yaml).

#### Example

```
kubectl get pods -o json  # Get pod details in JSON format
```

### Sorting list objects

Sort list objects with the `--sort-by` flag and a JSONPath expression specifying the sort field.

#### Example

```
kubectl get pods --sort-by=.metadata.name  # Sort pods by name
```