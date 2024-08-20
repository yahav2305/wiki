---
title: 'Packaging and Signing Charts'
draft: false
weight: 160
series: ["Helm"]
series_order: 160
---
It is possible to package, sign, upload, and verify Helm charts, ensuring secure distribution and authenticity.
# Packaging Charts
To package your Helm chart into a single compressed archive:
```bash
helm package ./<chart-dir>
```
This command creates a `.tgz` file containing your chart.
# Signing Charts
Signing charts ensures that the chart's authenticity can be verified by others.
## Steps to Sign a Helm Chart
1. **Generate a Key Pair:**
   - For quick key generation:
	```bash
	 gpg --quick-generate-key "John Smith"
	 ```
   - For production environments (more options):
	```bash
	 gpg --full-generate-key "John Smith"
	 ```
1. **Convert Keys to the Older Format:** Helm prefers the older GnuPG format (v1):
	```bash
	gpg --export-secret-keys > ~/.gnupg/secring.gpg
	```
1. **Package and Sign the Chart:**
	```bash
	helm package --sign --key 'John Smith' --keyring ~/.gnupg/secring.gpg ./<chart-dir>
	```
   - If you forget your key details, use:
	```bash
	gpg --list-keys
	 ```
1. **Verify Signature File**: When you sign a chart, an additional `.prov` file is created in the format: `<chart-dir-name>-<version>.tgz.prov`. This file contains the expected hash of the chart `.tgz` file. You can verify the hash using:
	```bash
	 sha256sum <chart-dir-name>-<version>.tgz
	 ```
   - Compare this hash with the one in the `.prov` file.
## Uploading and Downloading Charts
Upload both the `.tgz` and `.prov` files to your remote repository so that users can verify the authenticity of your chart.
Verifying a Downloaded Chart:
1. **Export Public Key**: Convert your public key to a format suitable for verification:
	```bash
	gpg --export 'John Smith' > mypublickey
	```
1. **Verify the Chart**: Use the public key to verify the downloaded chart:
	```bash
	helm verify --keyring ./mypublickey ./<chart-dir-name>-<version>.tgz
	```
1. **Install and Verify in One Step**:
	```bash
	helm install --verify <chart-dir-name>-<version>
	```