---
title: 'Yaml'
draft: false
---
# Table of Contents

- [YAML](#yaml)

# YAML
YAML is a human-readable data format used to define configurations in Kubernetes. It serves as the primary way to describe and deploy Kubernetes objects.

YAML files will always have 4 fields:
- **apiVersion**: Certain objects require certain api versions.
- **kind**: The kind of the object we are trying to create.
- **metadata**: information on the object, like name and labels.
- **spec**: The desired state of the object.

An example of a yaml file (that creates a pod):
```yaml
apiVersion: v1
kind: Pod
metadata:
name: nginx
spec:
containers:
  - name: nginx
    image: nginx:1.14.2
    ports:
    - containerPort: 80
```

| `kubectl create -f file.yaml` | Create object according to given yaml file |
| --- | --- |