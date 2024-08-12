---
title: API Versions
draft: false
weight: 31
series:
  - Kubernetes
series_order: 31
---
Kubernetes API versions are a crucial part of managing the lifecycle and stability of features within the platform. These versions indicate the maturity and stability of different features and APIs, guiding users on how to interact with them and what to expect in terms of support and compatibility.
# API Version Levels
## Alpha
- **Version Naming**: Includes `alpha` (e.g., `v1alpha1`).
- **Stability:** 
	- High risk of bugs and instability.
	- Features may be incomplete and are often disabled by default.
- **Support:**
	- Features can be removed or changed without notice.
	- Not recommended for production use; suitable for short-lived testing environments.
	- Changes in API can be incompatible with future versions.
## Beta
- **Version Naming**: Includes `beta` (e.g., `v2beta3`).
- **Stability:**
	- Features are well-tested and generally considered stable for use.
	- Features are typically enabled by default.
- **Support:**
	- Features are unlikely to be removed, but details may still change.
	- API changes could be incompatible with future versions, but migration instructions are usually provided.
	- Not fully recommended for production, but may be used if you can manage potential migrations or schema changes.
## Stable
- **Version Naming**: Uses the format `vX`, where `X` is a version number (e.g., `v1`, `v2`).
- **Stability:** 
	- The most stable and reliable version level.
	- Features have been thoroughly tested and used in many production environments.
- **Support:**
	- API versions at this level are considered permanent.
	- Backward-incompatible changes are avoided, ensuring long-term stability.
# Preferred/Storage Version
- **Preferred Version**: Among multiple supported API versions, one is designated as the "preferred" version, which is the default when using commands like `kubectl get` or `kubectl explain`.
- **Storage Version**: Objects stored in Kubernetes are saved using this version. If an object is retrieved that doesn’t match the storage version, it will be automatically converted to this version.
- **Importance**: Ensures consistency and ease of management, as the preferred/storage version is the default interface for most operations.