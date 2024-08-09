---
title: Jobs & CronJobs
draft: false
weight: 22
series:
  - Kubernetes
series_order: 22
---
In Kubernetes, Jobs and CronJobs are used to run tasks that are expected to terminate, such as batch processing or periodic tasks.
# Job
A Job creates one or more Pods and ensures that a specified number of them successfully complete. It will continue to retry the execution of Pods until the desired number of completions is achieved.
Deleting a Job will also clean up the Pods it created. Suspending a Job will delete its active Pods until the Job is resumed.

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: math-subtract-job
spec:
  completions: 8
  parallelism: 5
  template:
    spec:
      containers:
      - name: math-subtract
        image: ubuntu
        command: ["expr", "6", "-", "4"]
      restartPolicy: Never
```
- `parallelism`: Sets the number of Pods that can be created and run simultaneously.
- `completions`: The Job is complete when this number of Pods has successfully terminated.
# CronJob
A CronJob creates Jobs on a time-based schedule. CronJobs are useful for running periodic tasks, such as backups or report generation.

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: subtracting-cron-job
spec:
  schedule: "*/1 * * * *"
  jobTemplate:
    spec:
      completions: 8
      parallelism: 5
      template:
        spec:
          containers:
          - name: math-subtract
            image: ubuntu
            command: ["expr", "6", "-", "4"]
          restartPolicy: Never
```

- `schedule`: Specifies the Cron schedule in the format `*/1 * * * *` (every minute in this example).
- `jobTemplate`: Contains the template for the Job that will be created by the CronJob.