---
title: 'With Blocks'
draft: false
weight: 120
series: ["Helm"]
series_order: 120
---
Scope allows us easier access to a set of values from a `values.yaml` file.
# Understanding Scope
In Helm templates, everything starts at the **root scope**. If no specific scope is set, the template assumes we are in the root scope, which is why we need to traverse all the way from the root to access nested values.
Given a `values.yaml` file with the following nested dictionary:
```yaml
app:
  ui:
    bg: red
    fg: black
  db:
    name: "users"
    conn: "mongodb://localhost:27020/mydb"
```
We can set the following `configmap.yaml` file:
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}-appinfo
data:
  background: {{ .Values.app.ui.bg }}
  foreground: {{ .Values.app.ui.fg }}
  database: {{ .Values.app.db.name }}
  connection: {{ .Values.app.db.conn }}
```
# Using the `with` Block to Set Scope
To avoid unnecessary traversal, you can set a scope using the `with` block:
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}-appinfo
data:
  {{- with .Values.app }}
    {{- with .ui }}
    background: {{ .bg }}
    foreground: {{ .fg }}
    {{- end }}
    {{- with .db }}
    database: {{ .name }}
    connection: {{ .conn }}
    {{- end }}
  {{- end }}
```
- The `with` block sets a new scope, making it easier to access nested values without repetitive traversal.
- Scopes can be nested within each other as demonstrated.
# Accessing Values Outside the Current Scope
If you need to refer to a value outside of the current scope, use the `$` sign:
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}-appinfo
data:
  {{- with .Values.app }}
    {{- with .ui }}
    background: {{ .bg }}
    foreground: {{ .fg }}
    {{- end }}
    {{- with .db }}
    database: {{ .name }}
    connection: {{ .conn }}
    {{- end }}
  release: {{ $.Release.Name }}
  {{- end }}
```
- Here, `{{ $.Release.Name }}` refers to the `Release.Name` from the root scope, even within the nested `with` blocks.