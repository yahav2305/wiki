#!/bin/bash

set -e  # Exit when any command exits with a non-zero status

# Helm Repos
helm repo add projectcalico https://docs.tigera.io/calico/charts
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo add openebs https://openebs.github.io/openebs

# Calico
helm upgrade calico projectcalico/tigera-operator --install --atomic --create-namespace --values ./values/calico.yaml --version v3.28.0 --namespace tigera-operator

# OpenEBS
helm upgrade openebs openebs/openebs --install --atomic --create-namespace --values ./values/openebs.yaml --version 4.1.0 --namespace openebs

# Istio
helm upgrade istio-base istio/base --install --atomic --create-namespace --values ./values/istio-base.yaml --version 1.22.2 --namespace istio-system
helm upgrade istio-cni istio/cni --install --atomic --create-namespace --values ./values/istio-cni.yaml --version 1.22.2 --namespace istio-system
helm upgrade istiod istio/istiod --install --atomic --create-namespace --values ./values/istiod.yaml --version 1.22.2 --namespace istio-system
kubectl label namespace default istio-injection=true # Enable istio sidecar injection in relevant namespaces before deploying apps in them

