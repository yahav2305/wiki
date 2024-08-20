---
title: 'Making Sure Chart is Working as Intended'
draft: false
weight: 80
series: ["Helm"]
series_order: 80
---
We can use multiple methods for validating the correctness of a Helm chart.
# Helm Lint
The `helm lint` command performs a static analysis of a chart, checking for syntax errors, best practices, and potential issues. Key benefits include:
- **Syntax Validation:** Ensures YAML files adhere to correct formatting.
- **Best Practice Recommendations:** Provides guidance on improving chart structure and organization.
- **Early Error Detection:** Identifies problems before proceeding to more advanced testing stages.
# Helm Template
The `helm template` command renders chart templates into Kubernetes manifests, allowing for visual inspection. This process helps identify:
- **Template Errors:** Reveals issues with template syntax or logic.
- **Value Injection:** Verifies that values from `values.yaml` are correctly substituted.
- **Manifest Accuracy:** Checks if generated manifests are as expected.
Using the `--debug` flag can be helpful for troubleshooting template rendering errors.
# Helm Dry Run
The `helm install --dry-run` command simulates a chart installation without actually deploying resources to the cluster. This enables:
- **Kubernetes Validation:** Checks for Kubernetes API compatibility and resource validation errors.
- **Configuration Verification:** Ensures that values and templates produce correct configurations.
- **Risk Mitigation:** Prevents accidental deployment of incorrect configurations.