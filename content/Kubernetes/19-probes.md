---
title: Multi Container Pods
draft: false
weight: 18
series:
  - Kubernetes
series_order: 18
---
Probes are periodic checks to monitor the health of an application or to ensure that it started successfully and is ready to accept requests. They are useful since applications running in containers may take time to start up, to be ready, or may not be able to take requests while running, and we want to be able to react accordingly.
# Probe Types
## Startup Probe
Startup probes are used to check if the application running in the container has started. This is especially useful for applications that are slow to start so that they will not be killed by the kubelet before getting the chance to start. Startup probes are sent only when the pod is about to start.
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-pod
spec:
  containers:
  - name: nginx
    image: nginx
    startupProbe:
      httpGet:
        path: /api/live
        port: 8080
```
## Readiness Probe
Readiness probes are used to ensure that a container is ready to accept requests. This helps in cases where a container may take some time to start and be fully functional.
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-pod
spec:
  containers:
  - name: nginx
    image: nginx
    readinessProbe:
      httpGet:
        path: /api/ready
        port: 8080
```
## Liveness Probe
Liveness probes are used to check if the application inside the container is still running. If the application gets stuck or stops responding, the liveness probe can help by restarting the container.
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-pod
spec:
  containers:
  - name: nginx
    image: nginx
    livenessProbe:
      httpGet:
        path: /api/live
        port: 8080
```
# Probe Check Methods
## Exec
Executes a specific command inside the container. If error code 0 is returned, the container is considered ready.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-pod
spec:
  containers:
  - name: nginx
    image: nginx
    readinessProbe:
      exec:
        command:
        - cat
        - /app/ready
```
## TcpSocket
Attempts to open a TCP socket using the specified port on the container. If the socket is open, the probe is successful; otherwise, it is failed.
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-pod
spec:
  containers:
  - name: nginx
    image: nginx
    readinessProbe:
      tcpSocket:
        port: 8080
```
## HttpGet
Sends an HTTP request to the specified path using the specified port. Any code greater than or equal to 200 and less than 400 indicates success. Any other code indicates failure.
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-pod
spec:
  containers:
  - name: nginx
    image: nginx
    readinessProbe:
      httpGet:
        path: /api/ready
        port: 8080
```
## gRPC
Checks if the container is ready by accessing a specific port. The container must implement the [gRPC Health Checking Protocol](https://github.com/grpc/grpc/blob/master/doc/health-checking.md) in the specified port.
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-pod
spec:
  containers:
  - name: nginx
    image: nginx
    readinessProbe:
      grpc:
        port: 8080
```
## Additional Options
We can specify additional options for the check methods:
- **initialDelaySeconds**: Number of seconds after the container has started before the readiness probe is initiated. Defaults to 0 seconds. Minimum value is 0.
- **periodSeconds**: How often (in seconds) to perform the probe. Defaults to 10 seconds. The minimum value is 1.
- **timeoutSeconds**: Number of seconds after which the probe times out. Defaults to 1 second. Minimum value is 1.
- **successThreshold**: Minimum consecutive successes for the probe to be considered successful after having failed. Defaults to 1. Minimum value is 1.
- **failureThreshold**: When a probe fails, Kubernetes will try failureThreshold times before giving up. Giving up means the pod will be marked Unready. Defaults to 3. Minimum value is 1.
- **terminationGracePeriodSeconds**: Configures a grace period to wait between triggering a shutdown of the failed container and then forcing the container runtime to stop that container. The default is to inherit the Pod-level value for `terminationGracePeriodSeconds` (30 seconds if not specified). The minimum value is 1.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-pod
spec:
  containers:
  - name: nginx
    image: nginx
    readinessProbe:
      httpGet:
        path: /api/ready
        port: 8080
      initialDelaySeconds: 5
      periodSeconds: 5
      timeoutSeconds: 7
      successThreshold: 3
      failureThreshold: 3
      terminationGracePeriodSeconds: 60
```