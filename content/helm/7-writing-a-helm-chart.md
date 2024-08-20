---
title: 'Writing a Helm Chart'
draft: false
weight: 70
series: ["Helm"]
series_order: 70
---
This guide outlines the steps to create a basic Helm chart for deploying a simple application with a Deployment and Service.

1. **Generate Skeleton:** Use `helm create` to create a directory structure for your chart, named `nginx-chart` in this example.
2. **Modify chart.yaml:** Update the `chart.yaml` file with relevant information like name, version, and dependencies (if applicable).
3. **Template Cleanup (Optional):** The templates directory may contain placeholder files. Remove them if not needed (e.g., `rm -r templates/*`).
4. **Move YAML Files:** Move your Deployment and Service YAML files to the `templates` directory.
5. **Templating YAML:** Leverage Helm templates to define dynamic values in your YAML files.
	- Example Deployment Template:
	```yaml
	apiVersion: apps/v1
	kind: Deployment
	metadata:
      # Use Release.Name to avoid name conflicts
	  name: {{ .Release.Name }}-nginx 
	spec:
	  # Reference replicaCount from values.yaml
	  replicas: {{ .Values.replicaCount }}
	  selector:
		matchLabels:
		  app: {{ .Release.Name }}-hello-world
	  template:
		metadata:
		  labels:
			app: {{ .Release.Name }}-hello-world
		spec:
		  containers:
			- name: hello-world
			  # Reference nested image values
			  image: {{ .Values.image.repository }}:{{ .Values.image.tag    }}
			  ports:
				- name: http
				  containerPort: 80
				  protocol: TCP
	```
	- Example Service Template (similar approach):
	```yaml
	apiVersion: v1
	kind: Service
	metadata:
	  name: {{ .Release.Name }}-svc
	spec:
	  type: NodePort
	  ports:
		- port: 80
		  targetPort: http
		  protocol: TCP   
	  selector:
		app: {{ .Release.Name }}-hello-world
	```
    - Template Directives:
        - `.`: denotes the start of a template directive.
        - `.Release.Name`: refers to the release name specified during installation.
        - `{{ .Values.key }}`: references values defined in the `values.yaml` file (case-sensitive).
# Value Types
**Built-in Values:**
- Built-in values (starting with a capital letter) are pre-defined by Helm
- Example build-in values about Helm: `.Release.Namespace`, `Release.Name`, `Release.IsUpgrade`, etc.
- Example build-in values about Kubernetes: `Capabilities.KubeVersion`, `Capabilities.ApiVerison`, `Capabilities.HelmVersion`, etc.
**Custom Values:**
- Custom values are defined by the `values.yaml` file
- Must match their corresponding key names.
- Example values: `.Values.replicaCount`, `.Values.image`, etc.