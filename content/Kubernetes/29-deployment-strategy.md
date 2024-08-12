---
title: Deployment Strategies
draft: false
weight: 29
series:
  - Kubernetes
series_order: 29
---
When deploying new versions of an application, different strategies can be employed to ensure a smooth and error-free rollout. Two commonly used strategies in Kubernetes are Blue-Green and Canary deployments.
# Blue-Green Deployment
Blue-Green deployment involves maintaining two identical environments: a "blue" environment (the current production) and a "green" environment (the staging environment for the new version). The green environment is used to deploy and test the new version of the application. Once it is confirmed that the new version is functioning correctly, traffic is switched from the blue environment to the green environment, making green the new production environment.
## Steps for Blue-Green Deployment
1. **Deploy the New Version**: 
   - Create a new deployment for the green environment, specifying a unique label to differentiate it from the blue (current production) deployment.
    ```yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: myapp-green
    spec:
      replicas: 3
      selector:
        matchLabels:
          app: myapp
          environment: green
      template:
        metadata:
          labels:
            app: myapp
            environment: green
        spec:
          containers:
          - name: myapp
            image: myapp:v2  # New version
    ```
2. **Test the New Deployment**: 
   - Run tests on the green environment to ensure that the new version is working correctly.
3. **Switch Traffic**: 
   - Update the service that routes traffic to the application to point to the green environment instead of the blue environment by changing the selector in the service definition.
    ```yaml
    apiVersion: v1
    kind: Service
    metadata:
      name: myapp-service
    spec:
      selector:
        app: myapp
        environment: green  # Switch traffic to the green environment
      ports:
      - protocol: TCP
        port: 80
        targetPort: 8080
    ```
4. **Monitor and Rollback** (if needed):
   - After switching traffic, monitor the application for any issues. If a problem is detected, rollback by switching the service back to the blue environment.
## Advantages
- Quick rollback to the previous version if something goes wrong.
- Minimal downtime during the transition.
## Considerations
- Requires double the infrastructure during deployment.
# Canary Deployment
Canary deployment allows you to release a new version to a small subset of users or traffic. It’s a gradual rollout strategy where you start by directing a small percentage of traffic to the new version (canary) while the rest continues to go to the old version. If the canary version performs well, it is gradually rolled out to more users until it fully replaces the old version.
## Steps for Canary Deployment
1. **Deploy the New Version**:
   - Create a new deployment for the canary version with just one pod to start with.
    ```yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: myapp-canary
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: myapp
          version: canary
      template:
        metadata:
          labels:
            app: myapp
            version: canary
        spec:
          containers:
          - name: myapp
            image: myapp:v2  # New canary version
    ```
2. **Route Traffic**:
   - Update the service to route traffic to both the old and canary deployments by using the same label for both.
    ```yaml
    apiVersion: v1
    kind: Service
    metadata:
      name: myapp-service
    spec:
      selector:
        app: myapp  # Routes to both old and canary versions
      ports:
      - protocol: TCP
        port: 80
        targetPort: 8080
    ```
3. **Monitor the Canary Deployment**:
   - Monitor the performance and health of the canary version. If it performs well, proceed with scaling up.
4. **Scale the Canary Deployment**:
   - Gradually increase the number of pods in the canary deployment until it matches the number of pods in the old deployment.
    ```bash
    kubectl scale deployment myapp-canary --replicas=3
    ```
5. **Remove the Old Deployment**:
   - Once the canary version is fully deployed, you can safely delete the old version.
    ```bash
    kubectl delete deployment myapp-old
    ```
## Advantages
- Gradual rollout minimizes the risk of widespread issues.
- Allows real-time monitoring and feedback from a small subset of users.
## Considerations
- Requires careful monitoring to ensure the canary version behaves as expected.
- The complexity of managing traffic distribution between versions.