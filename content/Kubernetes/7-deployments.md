---
title: 'Deployments'
draft: false
---

Deployments are Kubernetes objects that manage the lifecycle of pod updates for your applications. They provide a declarative way to specify the desired state of your deployment, including the number of replicas, container image, and configuration. Kubernetes then automatically plans and executes the rollout process, ensuring minimal disruption to your application's availability.

Here's a breakdown of key deployment concepts:

- **Rolling Updates:** Deployments facilitate rolling updates, where outdated pods are gradually replaced with updated ones. This ensures that at least some healthy pods are always available during the update process.
- **Deployment Strategy:** Deployments implement a rolling update strategy by creating a new ReplicaSet with the updated pods and scaling it up while scaling down the old ReplicaSet with outdated pods.
- **Rollout History:** Deployments track the history of their updates, allowing you to roll back to a previous version if necessary.

## kubectl Commands for Deployments

- **Viewing Deployment History:**
    
    - `kubectl rollout history deployment/<deployment-name>`
		- This command displays the history of versions deployed for a specific deployment named `<deployment-name>`.
- **Rollback to Previous Version:**
    
    - `kubectl rollout undo deployment/<deployment-name>`
	    - This command attempts to rollback the deployment to the previous version.
- **Rollback to Specific Version:**
    
    - `kubectl rollout undo deployment/<deployment-name> --to-revision=<revision-number>`
	    - This command allows you to rollback to a specific version identified by its revision number.
- **Scaling Deployments:**
    
    - `kubectl scale deployment/<deployment-name> --replicas=<number>`
	    - This command allows you to adjust the desired number of replicas for a deployment.
- **Pausing/Resuming Rollouts:**
    
    - `kubectl rollout pause deployment/<deployment-name>`
	    - This command pauses an ongoing rollout of a deployment.
    - `kubectl rollout resume deployment/<deployment-name>`
	    - This command resumes a paused rollout.

## Deployment Creation YAML

The provided YAML snippet demonstrates how to define a Deployment in a YAML file:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment  # Name of the deployment
  labels:                # Labels to associate with the deployment
    app: nginx
spec:
  replicas: 3            # Desired number of pod replicas
  selector:              # Selector to identify pods managed by the deployment
    matchLabels:
      app: nginx
  template:             # Pod template used to create new pods for the deployment
    metadata:
      labels:            # Labels applied to pods created by this deployment
        app: nginx
    spec:
      containers:
      - name: nginx        # Name of the container within the pod
        image: nginx:1.14.2  # Container image
        ports:
        - containerPort: 80  # Container port to expose
```

**Key Points:**

- **apiVersion:** Specifies the Kubernetes API version used for deployments (apps/v1).
- **kind:** Indicates the type of object being defined (Deployment).
- **metadata.labels:** Labels to associate with the deployment itself.
- **spec.replicas:** The desired number of pod replicas for the deployment.
- **spec.selector:** A label selector to identify pods that the deployment manages.
- **spec.template:** The pod template used to create new pods for the deployment (similar to ReplicaSets).

## Updating Deployments

To update a deployment with a new container image, you simply modify the `image` field within the `spec.template.containers` section of your deployment YAML file and apply the updated YAML. Kubernetes then initiates a rolling update to bring up new pods with the updated image while phasing out old pods.