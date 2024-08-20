---
title: 'Ranges'
draft: false
weight: 130
series: ["Helm"]
series_order: 130
---
Ranges allow us to execute code multiple times for multiple elements in a list.
# Example
Let's say we have a list of regions in a `values.yaml` file:
```yaml
regions:
  - ohio
  - newyork
  - ontario
  - london
  - singapore
  - mumbai
```
We can automatically populate a ConfigMap with these values in quotes using a `range` block:
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}-regioninfo
data:
  regions:
  {{- range .Values.regions }}
  - {{ . | quote }}
  {{- end }}
```
After the `range` block executes, the resulting ConfigMap will look like this:
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}-regioninfo
data:
  regions:
  - "ohio"
  - "newyork"
  - "ontario"
  - "london"
  - "singapore"
  - "mumbai"
```
# How the `range` Block Works
- The `range` block loops through each element in the list defined by `.Values.regions`.
- **Scope in `range`:** Each loop iteration sets the scope to the current list element. For instance:
  - In the first loop, the scope (`.`) is set to `ohio`.
  - In the second loop, the scope is set to `newyork`, and so on.
- **Using the Pipe (`|`) Operator:** We pipe the current element (`.`) into the `quote` function to wrap the value in quotes.