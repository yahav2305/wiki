---
title: 'Customizing Chart Parameters'
draft: false
weight: 50
series: ["Helm"]
series_order: 50
---
We can customize the default values of a Helm chart or override them in multiple ways.
# Overriding the Default Values
You can override the default values of a helm chart with your own values.
## Using the Command Line Interface (CLI)
You can override specific values directly in the CLI when installing the chart. Use the `--set` flag to specify the variable and its new value:
```sh
helm install \
--set <variable-name>=<variable-value> \
<release-name> <repo>/<chart>
```
- This method allows you to pass multiple parameters by using the `--set` flag multiple times.
## Using a Custom `values.yaml` File
You can create your own custom `values.yaml` file to specify the values you want to override:
```yaml
<variable-name-1>: <variable-value-1>
<variable-name-2>: <variable-value-2>
```

To use this custom file during installation, pass it with the `--values` flag:
```sh
helm install \
--values <path-to-values.yaml> \
<release-name> <repo>/<chart>
```
# Changing the Default Values
If you need to change the default values directly in the chart:
1. **Pull the Chart Locally:**
	- Download the chart to your local system using the `helm pull` command:
	```sh
	helm pull <repo>/<chart>
	```
	- To pull and uncompress the chart in one step, use:
	```sh
	helm pull --untar <repo>/<chart>
	```
2. **Edit the `values.yaml` File:**
	- Navigate to the chart directory that was created and open the `values.yaml` file. Make your desired changes directly in this file.
3. **Install the Modified Chart:**
	- After making your changes, install the chart using the modified `values.yaml`:
	```sh
	helm install <release-name> ./<chart>
	```
   - This approach changes the default values in the chart itself before deployment.