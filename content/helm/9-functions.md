---
title: 'Functions'
draft: false
weight: 90
series: ["Helm"]
series_order: 90
---
Helm offers a variety of functions that help manipulate, transform and alter data within templates.
They can be used for value manipulation, default values and more.
# Helm Functions for Value Manipulation
Common string manipulation functions include:
- `{{ upper .Values.image.repository }}`: Converts the image repository name to uppercase (e.g., `NGINX`).
- `{{ quote .Values.image.repository }}`: Adds quotes around the repository name (e.g., `"nginx"`).
- `{{ replace "x" "y" .Values.image.repository }}`: Replaces occurrences of "x" with "y" in the repository name (e.g., `"nginy"`).
- `{{ shuffle .Values.image.repository }}`: Randomly shuffles the letters in the repository name (e.g., `"xignn"` - note: not a recommended practice for production use).
**Explore more functions:** Refer to the Helm documentation for a comprehensive list of functions covering strings, numbers, lists, conditionals, and more: [https://helm.sh/docs/chart_template_guide/function_list/](https://helm.sh/docs/chart_template_guide/function_list/)
# Setting Default Values
The `default` function allows you to specify a fallback value for a missing key in `values.yaml`. Here's how it works:
```yaml
{{ default "nginx" .Values.image.repository }}
```
This translates to: "If the value for `image.repository` doesn't exist in `values.yaml`, use 'nginx' as the default."
This approach ensures that your chart functions even when users don't provide specific values during installation.