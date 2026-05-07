#!/usr/bin/env bash
set -euo pipefail
KUBECONFIG_PATH="${1:-./kubeconfig.yaml}"
export KUBECONFIG="$KUBECONFIG_PATH"

kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl -n argocd rollout status deployment/argocd-server --timeout=180s || true
echo "ArgoCD installed in namespace argocd"
