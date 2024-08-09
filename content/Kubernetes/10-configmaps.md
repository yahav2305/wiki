---
title: 'ConfigMaps'
draft: false
weight: 10
series: ["Kubernetes"]
series_order: 10
---

Used to store environment variables in a separate, callable file, making them more convenient than specifying them each time.
ConfigMaps store environment variables as key-value pairs.
### `kubectl` Commands
| Command                                                                   | Description                                                                                                                 |
| ------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------- |
| `kubectl create configmap <configmap-name> --from-literal=<key>=<value>`  | Create configmap using the specified name, key, and value. `--from-literal` can be used multiple times for multiple values. |
| `kubectl create configmap <configmap-name> --from-file=config.properties` | Create configmap using the specified name and data from the specified file.                                                 |
# ConfigMap Yaml Definition File
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  APP_COLOR: blue
  APP_MODE: prod
```
# Injecting ConfigMap data into containers
There are multiple ways to inject data from a configMap into a container.
## Injecting all key-value pairs in a configMap as container environment variables
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-pod
spec:
  containers:
  - name: nginx
    image: nginx
    envFrom:
    - configMapRef:
        name: special-config
```
## Injecting specific key-value pairs in a configMap as container environment variables
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-pod
spec:
  containers:
    - name: nginx
      image: nginx
      env:
      - name: ENV-KEY-NAME
        valueFrom:
			configMapKeyRef:
	            # The ConfigMap containing the value you want to assign to ENV-KEY-NAME
	            name: CONFIGMAP-NAME
	            # Specify the key from the configmap
	            key: KEY-NAME
```
## Injecting configMap as a file into container
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
	  - name: config-volume
		mountPath: /etc/config
  volumes:
    - name: config-volume
      configMap:
        # Provide the name of the ConfigMap containing the files you want
        # to add to the container
        name: CONFIGMAP-NAME
```