---
title: 'Uploading Charts'
draft: false
weight: 170
series: ["Helm"]
series_order: 170
---
This article will demonstrate how to upload your charts and how to initialize a repository.
# Repository Components
A typical Helm chart repository contains the following key files:
- **Compressed Chart (`.tgz`)**: The packaged Helm chart.
- **`index.yaml`**: Contains metadata about the charts in the repository, including their versions, descriptions, and checksums.
- **Provenance File (`.prov`)**: Used for verifying cryptographic signatures to ensure the integrity and authenticity of the chart.
# Generating the `index.yaml` File
Steps to Create `index.yaml`:
1. **Prepare the Repository Directory**:
   - Create a directory that will serve as your chart repository. For example:
     ```bash
     mkdir <chart-dir-name>
     ```
2. **Move Chart Files to the Repository Directory**:
   - Move your packaged chart (`.tgz`) and its corresponding provenance file (`.prov`) into the directory:
     ```bash
     mv <chart-dir-name>-<version>.tgz <chart-dir-name>
     mv <chart-dir-name>-<version>.tgz.prov <chart-dir-name>
     ```
3. **Generate the `index.yaml` File**:
   - Run the following command to create the `index.yaml` file:
     ```bash
     helm repo index <chart-dir-name>/ --url https://example.com/charts
     ```
   - **`--url` flag**: This points to the base URL where your chart repository will be hosted (replace `https://example.com/charts` with your actual URL).
Explanation:
- The `index.yaml` file is crucial for Helm to recognize and interact with your repository. It lists all available charts, their versions, and where they can be downloaded from.