---
title: 'Security Context'
draft: false
weight: 12
series: ["Kubernetes"]
series_order: 12
---

Defines privilege and access control settings for a Pod or Container. Security context settings include:
- **Discretionary Access Control**: Permission to access an object, like a file, is based on [user ID (UID) and group ID (GID)](https://wiki.archlinux.org/index.php/users_and_groups).
- **[Security Enhanced Linux (SELinux)](https://en.wikipedia.org/wiki/Security-Enhanced_Linux)**: Objects are assigned security labels.
- **Running as privileged or unprivileged**.
- **[Linux Capabilities](https://linux-audit.com/linux-capabilities-hardening-linux-binaries-by-removing-setuid/)**: Give a process some privileges, but not all the privileges of the root user.
- **[AppArmor](https://kubernetes.io/docs/tutorials/security/apparmor/)**: Use program profiles to restrict the capabilities of individual programs.
- **[Seccomp](https://kubernetes.io/docs/tutorials/security/seccomp/)**: Filter a process's system calls.
- `allowPrivilegeEscalation`: Controls whether a process can gain more privileges than its parent process.
- `readOnlyRootFilesystem`: Mounts the container's root filesystem as read-only.
# Security Context Priority
It is possible to define security context that will affect the container and/or the pod. Security context that affects the pod will affect all the containers inside of it. If there is a security context that affects both the container and the pod, the security context on the container level will get priority over the security context on the pod level.
# Pod-Level Security Context
To set security context that affects the pod, see `securityContext` under `spec`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-pod
spec:
  securityContext:
    runAsUser: 1000
  containers:
  - name: nginx
    image: nginx
```
# Container-Level Security Context
To set security context that affects the container, see `securityContext` under `spec`, `containers`:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-pod
spec:
  containers:
  - name: nginx
    image: nginx
    securityContext:
      runAsUser: 2000
      capabilities:
        add: ["NET_ADMIN", "SYS_TIME"]
```