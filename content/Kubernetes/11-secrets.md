---
title: 'Secrets'
draft: false
weight: 11
series: ["Kubernetes"]
series_order: 11
---

Stores data in key-value pairs like ConfigMaps, but in base64.
# `kubectl` Commands
| Command                                                                             | Description                                                                                                              |
| ----------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ |
| `kubectl create secret generic <secret-name> --from-literal=<key-name>=<key-value>` | Create secret using the specified name, key, and value. `--from-literal` can be used multiple times for multiple values. |
| `kubectl create secret generic <secret-name> --from-file=secret.properties`         | Create secret using the specified name and data from the specified file.                                                 |
# Secret creation file:
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: mysecret
data:
  USER_NAME: ZWFzdGVy
  PASSWORD: ZWdn
```
- Values of keys in secrets can be decoded by using the following command on Linux:
```bash
echo -n <value> | base64 --decode
```
# Calling Secrets from resource creation files
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secret-test-pod
spec:
  containers:
    - name: nginx
      image: nginx
      envFrom:
      - secretRef:
          name: mysecret
```

**Note**: It is not recommended to use secrets for security purposes because there is no encryption, only conversion. Tools like Helm secrets or [HashiCorp Vault](https://www.vaultproject.io/) can be used to encrypt data in Kubernetes.