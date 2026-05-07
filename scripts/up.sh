#!/usr/bin/env bash
set -euo pipefail
TF_DIR="infra/terraform"

pushd "$TF_DIR" >/dev/null
terraform init
terraform apply -auto-approve
popd >/dev/null

KUBECONFIG_PATH=$(cd "$TF_DIR" && terraform output -raw kubeconfig_path 2>/dev/null || echo "../kubeconfig.yaml")
echo "kubeconfig: $KUBECONFIG_PATH"

# install argocd (idempotent)
"$PWD/infra/scripts/install_argocd.sh" "$TF_DIR/../kubeconfig.yaml" || true
echo "Cluster up. Export KUBECONFIG as needed."
