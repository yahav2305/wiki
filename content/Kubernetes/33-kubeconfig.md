---
title: kubeConfig
draft: false
weight: 33
series:
  - Kubernetes
series_order: 33
---
The `kubeconfig` file is a crucial component in Kubernetes, enabling the `kubectl` command-line tool to interact with the Kubernetes API server. It stores information about clusters, users, and contexts, and helps manage access to multiple Kubernetes clusters.
# Kubeconfig File Structure
A typical `kubeconfig` file is structured into three primary sections:
## Clusters
This section defines the clusters that `kubectl` can connect to, including the cluster name, server address, and certificate information.
## Users
This section specifies the users who can authenticate with the clusters. It includes details like client certificates and keys required for authentication.
## Contexts
Contexts combine a cluster, a user, and a namespace into a single configuration that can be switched between easily. The `current-context` field indicates which context `kubectl` is using by default.
## Example Kubeconfig File
```yaml
apiVersion: v1
kind: Config
preferences: {}
clusters:
- cluster:
    certificate-authority-data: <ca-data>
    server: https://<cluster-api-server-1>:6443
  name: cluster-1
- cluster:
    certificate-authority: <ca-file-path>
    server: https://<cluster-api-server-2>:6443
  name: cluster-2
users:
- name: user-1
  user:
    client-certificate-data: <cert-data>
    client-key-data: <key-data>
- name: user-2
  user:
    client-certificate: <cert-file-path>
    client-key: <key-file-path>
contexts:
- context:
    cluster: cluster-1
    user: user-1
    namespace: namespace-1
  name: context-1
- context:
    cluster: cluster-2
    user: user-2
    namespace: namespace-2
  name: context-2
current-context: context-1
```
# Using Kubeconfig
To avoid human errors, it's recommended to manipulate the `kubeconfig` file using `kubectl config` commands instead of editing it directly.
## General Commands
View Kubeconfig:
```sh
kubectl config view
```
- This command displays the `kubeconfig` content, showing how multiple files are merged if more than one is present.

Switch Context:
```sh
kubectl config use-context <context-name>
```
- Switches the current context to the specified one.
## Cluster Management
Display All Clusters:
```sh
kubectl config get-clusters
```

Add Cluster:
```sh
kubectl config set-cluster <cluster-name> \
--server=https://<cluster-api-server> \
--certificate-authority='<path-to-ca-file>'
```

Add Cluster Without Certificate Checking:
```sh
kubectl config set-cluster <cluster-name> \
--server=https://<cluster-api-server> \
--insecure-skip-tls-verify=true
```

Edit Existing Cluster:
```sh
kubectl config set-cluster <cluster-name> \
--<property>=<value>
```

Delete Cluster:
```sh
kubectl config delete-cluster <cluster-name>
```
## User Management
Display All Users:
```sh
kubectl config get-users
```

Add User:
```sh
kubectl config set-credentials <user-name> \
--client-certificate=<path-to-cert-file> \
--client-key=<path-to-key-file>
```

Edit Existing User:
```sh
kubectl config set-credentials <user-name> \
--<property>=<value>
```

Delete User:
```sh
kubectl config delete-user <user-name>
```

## Context Management
Display All Contexts:
```sh
kubectl config get-contexts
```

Add Context:
```sh
kubectl config set-context <context-name> \
--cluster=<cluster-name> \
--user=<user-name> \
--namespace=<namespace>
```

Edit Existing Context:
```sh
kubectl config set-context <context-name> \
--<property>=<value>
```

Delete Context:
```sh
kubectl config delete-context <context-name>
```
# Specifying Kubeconfig File Location
## Default Location
By default, `kubectl` looks for the `kubeconfig` (named `config`) file at the directory `$HOME/.kube` on Linux or `%UserProfile%\.kube` on Windows.
## Environment Variable
You can set the `KUBECONFIG` environment variable to specify one or more `kubeconfig` files. When multiple files are specified, they are merged.
## Specify in Command
You can also specify the `kubeconfig` file directly in a `kubectl` command:
```sh
kubectl get nodes \
--kubeconfig=<path-to-kubeconfig-file>
```