---
title: 'Chart Hooks'
draft: false
weight: 150
series: ["Helm"]
series_order: 150
---
Helm hooks allow you to execute additional actions during the lifecycle of a Helm release, such as backing up a database, sending alerts, or performing cleanup tasks.
# Typical Helm Workflow
1. **helm_upgrade**: Initiates the Helm upgrade.
2. **verify**: Ensures the chart is valid.
3. **render**: Renders the templates into Kubernetes manifests.
4. **upgrade**: Applies the rendered templates to the Kubernetes cluster.
# Hook Types
- **Pre-upgrade hook**: Runs before the upgrade phase.
- **Post-upgrade hook**: Runs after the upgrade phase.
- **Pre-install hook**: Runs before the install operation.
- **Post-install hook**: Runs after the install operation.
- **Pre-delete hook**: Runs before deletion requests.
- **Post-delete hook**: Runs after deletion requests.
- **Pre-rollback hook**: Runs before rollbacks.
- **Post-rollback hook**: Runs after rollbacks.
## Pre-Upgrade Hook
This hook allows you to run actions before the upgrade process. Helm waits for the hook to complete and reach a ready state before proceeding.
**Workflow with Pre-Upgrade Hook**:
1. helm_upgrade
2. verify
3. render
4. **pre-upgrade**
5. upgrade
## Post-Upgrade Hook
This hook is useful for performing cleanup or sending notifications after the upgrade phase has successfully completed.
**Workflow with Post-Upgrade Hook**:
1. helm_upgrade
2. verify
3. render
4. upgrade
5. **post-upgrade**
# Creating Hooks
Hooks are typically implemented as Kubernetes `Job` resources, running either continuously (as a pod) or once (as a job).
**Example of a Pre-Upgrade Hook:**
```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ .Release.Name }}-nginx
  annotations:
    "helm.sh/hook": pre-upgrade
spec:
  template:
    metadata:
      name: {{ .Release.Name }}-nginx
    spec:
      restartPolicy: Never
      containers:
      - name: pre-upgrade-backup-job
        image: "alpine"
        command: ["/bin/backup.sh"]
```
- **Placement:** Place this file in the `templates` directory of your Helm chart.
- **Hook Type:** Specify the hook type (e.g., `pre-upgrade`) in the `annotations` section.
# Managing Multiple Hooks
When you have multiple hooks for the same lifecycle event, you can control the order in which they run by setting weights.
## Setting Hook Weights
Helm sorts hooks by their weights (can be negative or positive) and runs them in ascending order.
**Example with Hook Weight:**
```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ .Release.Name }}-nginx
  annotations:
    "helm.sh/hook": pre-upgrade
    "helm.sh/hook-weight": "5"
spec:
  template:
    metadata:
      name: {{ .Release.Name }}-nginx
    spec:
      restartPolicy: Never
      containers:
      - name: pre-upgrade-backup-job
        image: "alpine"
        command: ["/bin/backup.sh"]
```
- **Sorting**: Hooks with the same weight are further sorted by resource kind and name in ascending order.
# Hook Cleanup
After a hook's job or pod completes, it remains on the cluster unless explicitly cleaned up. You can manage this with hook deletion policies.
## Setting Hook Deletion Policies
You can configure when to delete the hook resources by setting the `hook-delete-policy` annotation.
**Example with Hook Deletion Policy:**
```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ .Release.Name }}-nginx
  annotations:
    "helm.sh/hook": pre-upgrade
    "helm.sh/hook-weight": "5"
    "helm.sh/hook-delete-policy": hook-succeeded
spec:
  template:
    metadata:
      name: {{ .Release.Name }}-nginx
    spec:
      restartPolicy: Never
      containers:
      - name: pre-upgrade-backup-job
        image: "alpine"
        command: ["/bin/backup.sh"]
```
- **`hook-succeeded`**: Deletes the hook only if it succeeds.
- **`hook-failed`**: Deletes the hook even if it fails.
- **Default**: If no policy is specified, the default is `before-hook-creation`, which deletes the resource only when a new hook is about to be created.