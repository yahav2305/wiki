#!/bin/bash

set -e  # Exit when any command exits with a non-zero status

# Helm Repos
helm repo add projectcalico https://docs.tigera.io/calico/charts
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo add openebs https://openebs.github.io/openebs
helm repo add grafana https://grafana.github.io/helm-charts
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add falcosecurity https://falcosecurity.github.io/charts
helm repo update

# Calico
helm upgrade calico projectcalico/tigera-operator --install --atomic --create-namespace --values ./values/calico.yaml --version v3.28.0 --namespace tigera-operator

# OpenEBS
helm upgrade openebs openebs/openebs --install --atomic --create-namespace --values ./values/openebs.yaml --version 4.1.0 --namespace openebs
kubectl patch storageclass openebs-hostpath -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}' # Set openebs storage class as default

# Istio
helm upgrade istio-base istio/base --install --atomic --create-namespace --values ./values/istio-base.yaml --version 1.22.2 --namespace istio-system
helm upgrade istio-cni istio/cni --install --atomic --create-namespace --values ./values/istio-cni.yaml --version 1.22.2 --namespace istio-system
helm upgrade istiod istio/istiod --install --atomic --create-namespace --values ./values/istiod.yaml --version 1.22.2 --namespace istio-system
kubectl label namespace default istio-injection=true # Enable istio sidecar injection in relevant namespaces before deploying apps in them

# Loki
helm upgrade loki grafana/loki --install --atomic --create-namespace --values ./values/loki.yaml --version 6.6.6 --namespace monitoring

# Prometheus
helm upgrade prometheus prometheus-community/prometheus --install --atomic --create-namespace --values ./values/prometheus.yaml --version 25.24.0 --namespace monitoring

# Grafana
helm upgrade grafana grafana/grafana --install --atomic --create-namespace --values ./values/grafana.yaml --version 8.3.4 --namespace monitoring

# Promtail
helm upgrade protmail grafana/promtail --install --atomic --create-namespace --values ./values/promtail.yaml --version 6.16.4 --namespace monitoring

# Falco
helm upgrade falco falcosecurity/falco --install --atomic --create-namespace --values ./values/falco.yaml --version 4.6.3 --namespace falco

# Kube-Bench
kubectl apply -f ./resources/kube-bench.yaml
kubectl logs jobs/kube-bench
kubectl delete job kube-bench