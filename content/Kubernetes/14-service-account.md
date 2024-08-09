---
title: Service Accounts
draft: false
weight: 14
series:
  - Kubernetes
series_order: 14
---
There are two types of accounts in Kubernetes: user accounts for users and service accounts for programs.
Service accounts are mainly used by programs to perform automated tasks, such as Prometheus polling the Kubernetes API for performance metrics or Jenkins deploying applications on the Kubernetes cluster.
# Service Account and Tokens
When a service account is created, we can generate a unique token associated with it. The service using the service account must use that token to act as the service account.
## Requesting a Token for a Service Account
We can use the [TokenRequest API](https://kubernetes.io/docs/reference/kubernetes-api/authentication-resources/token-request-v1/) to issue an API request for a short-lived token for authenticating as a service account from our application or a sidecar container if our application is not Kubernetes-aware.
## Service Account Token Projection
We can associate a service account with a pod by adding `serviceAccountName` under `spec` in the pod creation file. This allows us to generate a service account token and mount it as a file in the pod:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-pod
spec:
  containers:
  - name: nginx
    image: nginx
    volumeMounts:
    - mountPath: /var/run/secrets/tokens
      name: sa-token
  serviceAccountName: test-serviceaccount
  volumes:
  - name: sa-token
    projected:
      sources:
      - serviceAccountToken:
        path: sa-token
```
- The path to the token inside the container will be: `/var/run/secrets/tokens/sa-token`.
- It is impossible to change the service account name while the pod is running. You must change it by deleting the pod and then creating it again.
## Opting Out of Automatic Service Account Token Association
You can opt out of automatically associating a service account with a pod by setting `automaticServiceAccountToken` to `false` under `spec` in the pod creation file:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
  - name: nginx
    image: nginx
  automountServiceAccountToken: false
  serviceAccountName: test-serviceaccount
```
- In the above file, the service account `test-serviceaccount` will not be created for the pod `my-pod` and must be created another way.
# `kubectl` Commands

| Command                                                 | Description                                                                                                      |
| ------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------- |
| `kubectl create serviceaccount <serviceaccount-name>`   | Create a service account with the specified name.                                                                |
| `kubectl describe serviceaccount <serviceaccount-name>` | Display information about the specified service account, including the name of the secret that stores its token. |
| `kubectl describe secret <secret-name>`                 | Display the token of the service account according to the secret name found in the service account.              |
