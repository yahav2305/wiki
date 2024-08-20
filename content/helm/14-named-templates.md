---
title: 'Named Templates'
draft: false
weight: 140
series: ["Helm"]
series_order: 140
---
Named templates, also known as partials, help reduce repetitive code in Helm templates by allowing you to define reusable snippets in a separate file.
# Use-Case
Consider the following template files with repeated label lines:
`deployment.yaml`
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Release.Name }}-nginx
  labels:
    app.kubernetes.io/name: nginx
    app.kubernetes.io/instance: nginx
spec:
  selector:
    matchLabels: 
      app.kubernetes.io/name: nginx
      app.kubernetes.io/instance: nginx
  template:
    metadata:
      labels:
        app.kubernetes.io/name: nginx
        app.kubernetes.io/instance: nginx
  spec:
    containers:
    - name: nginx 
	  image: "nginx:1.16.0"
      imagePullPolicy: IfNotPresent
      ports:
      - name: http
	    containerPort: 80
		protocol: TCP
```

`service.yaml`:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: {{ .Release.Name }}-nginx
  labels:
    app.kubernetes.io/name: nginx
    app.kubernetes.io/instance: nginx
spec:
  ports:
  - port: 80
    targetPort: http
    protocol: TCP
    name: http
  selector:
    app: hello-world
```
# Defining Named Templates
To reduce duplication, extract the repeated lines into a separate file named `_helpers.tpl`:
`_helpers.tpl`:
```yaml
{{- define "labels" }}	
    app.kubernetes.io/name: {{ .Release.Name }}
    app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
```
Key Points:
- **Underscore (`_`) Prefix**: The underscore in the filename `_helpers.tpl` tells Helm not to treat this file as a Kubernetes resource template.
- **Reusable Code**: The labels are defined in `_helpers.tpl` so they can be reused across multiple template files.
- **Dynamic Content**: Using `{{ .Release.Name }}` ensures that the labels are unique to each Helm release, avoiding conflicts.
# Using Named Templates
You can now include the named template in other template files:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: {{ .Release.Name }}-nginx
  labels:
    {{- template "labels" . }}
spec:
  ports:
  - port: 80
    targetPort: http
    protocol: TCP
    name: http
  selector:
    app: hello-world
```
# Scope Management
The `_helpers.tpl` file doesn’t inherently have access to any scope. You need to pass the necessary scope when including the named template using:
```yaml
{{- template "<template-name>" <scope> }}
```
# Handling Indentation in Named Templates
When using named templates, the lines from the helper file are inserted with the exact same indentation as they appear in the helper file. This can cause issues if you need to use the template in places with varying indentation levels.
To manage different indentations, use the `include` function along with the `indent` function:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Release.Name }}-nginx
  labels:
    {{- include "labels" . }}
spec:
  selector:
    matchLabels: 
      {{- include "labels" . | indent 2 }}
  template:
    metadata:
      labels:
        {{- include "labels" . | indent 4 }}
    spec:
      containers:
      - name: nginx 
        image: "nginx:1.16.0"
        imagePullPolicy: IfNotPresent
        ports:
        - name: http
          containerPort: 80
          protocol: TCP
```
- **`include` vs `template`**: Use `include` instead of `template` because `include` is a function, allowing you to pipe its output to another function like `indent`.