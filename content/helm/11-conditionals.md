---
title: 'Conditionals'
draft: false
weight: 110
series: ["Helm"]
series_order: 110
---
Helm conditionals empower you to control which parts of your templates are included in the generated manifests based on the presence of values or specific conditions.
# Using `if` Statements
We can use `if` statements to conditionally include sections of a YAML files.
```yaml
apiVersion: v1
kind: service
metadata:
  name: {{ .Release.name }}-nginx
  {{- if .Values.orgLabel }}  # Condition check
  labels:
    org: {{ .Values.orgLabel }}  # Include label if orgLabel exists
  {{- end }}  # End of conditional block
spec:
  ports:
    - port: 80
      name: http
  selector:
    app: hello-world
```
**Important Note:** The double curly braces (`{{`) with a hyphen (`-`) after them tell Helm to remove empty lines generated from the conditional block when the final YAML is created.
# `else if` and `else` Statements
Helm supports branching logic using additional conditional statements:
- `else if`: This allows you to define another condition to be checked if the initial `if` condition is not met.
- `else`: This specifies what to include if none of the previous conditions are true.
```yaml
apiVersion: v1
kind: service
metadata:
  name: {{ .Release.name }}-nginx
  {{- if .Values.orgLabel }}
  labels:
	org: {{ .Values.orgLabel }}
  {{- else if eq .Values.orgLabel "hr" }}
  labels:
    org: human resources
  {{- end }}
spec:
  ports:
  - port: 80
	name: http
  selector:
	app: hello-world
```
# Comparison Functions
The `eq` function mentioned above is one of several comparison operators available in Helm. Here's a list of common ones:
- `eq`: Equal to
- `ne`: Not equal to
- `lt`: Less than
- `le`: Less than or equal to
- `gt`: Greater than
- `ge`: Greater than or equal to
- `not`: Negation
- `empty`: Checks if a value is empty
# Addressing Empty Lines
We will want to remove empty lines that can be generated from using conditionals.
We can do it by specifying double curly braces with a hyphen after them (`{{-`) to tell Helm to remove empty lines generated from the conditional block when the final YAML is created.