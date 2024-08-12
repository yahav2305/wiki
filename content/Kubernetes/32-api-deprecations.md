---
title: API Deprecation
draft: false
weight: 32
series:
  - Kubernetes
series_order: 32
---
The Kubernetes API's evolution is governed by strict rules to ensure backward compatibility, stability, and seamless transitions between versions. These rules allow the API to grow and adapt while minimizing disruption to existing systems.
# API Groups and Versioning Tracks
Kubernetes APIs are divided into **API groups**, each independently versioned and following one of three main tracks:
- **GA (Generally Available, Stable)**: 
	- Version format: `v1`, `v2`, etc.
	- This track represents stable and production-ready features.
- **Beta (Pre-release)**:
	- Version format: `v1beta1`, `v2beta3`, etc.
	- Features are well-tested but may still change.
- **Alpha (Experimental)**:
	- Version format: `v1alpha1`, `v2alpha2`, etc.
	- Features are experimental, may be incomplete, and are subject to change or removal without notice.
A single Kubernetes release may support multiple versions across various API groups, allowing flexibility in API evolution.
# Rules Governing API Deprecation
## Rule #1: Incremental Version Removal
API elements can only be removed by incrementing the version of the API group. This ensures that once an element is included in a version, it remains unchanged within that version's track.
## Rule #2: Round-trip Compatibility
API objects must be able to convert (or "round-trip") between versions within a release without losing information. This rule ensures compatibility when downgrading or upgrading Kubernetes versions.
For example, an object written in `v1` should be convertible to `v2` and back to `v1` without data loss. The system must support bi-directional conversion between versions.
## Rule #3: Stability Level Preservation
A less stable API version (e.g., alpha or beta) cannot replace a more stable one:
- **GA** versions can replace beta or alpha versions.
- **Beta** versions can replace earlier beta or alpha versions but not GA versions.
- **Alpha** versions can only replace earlier alpha versions.
## Rule #4a: Minimum API Lifetime
- **GA Versions**: Can be deprecated but not removed within the same major Kubernetes version.
- **Beta Versions**: Must be supported for at least 9 months or 3 releases (whichever is longer) after deprecation.
- **Alpha Versions**: Can be removed at any time without prior notice.
## Rule #4b: Preferred and Storage Versions
The "preferred" API version and the "storage version" for an API group may not advance until after a release that supports both the new and previous versions. This rule ensures that users can upgrade or downgrade Kubernetes versions without breaking the system or needing to convert objects manually.
# Practical Tools and Commands
  Kubernetes provides the `kubectl convert` command to help migrate YAML files from one API version to another.
  Example:
```sh
kubectl convert -f <old-file> --output-version <new-api>
```
  - This command takes an old API version YAML file and converts it to the specified new API version.