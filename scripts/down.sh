#!/usr/bin/env bash
set -euo pipefail
TF_DIR="infra/terraform"
pushd "$TF_DIR" >/dev/null
terraform destroy -auto-approve || true
popd >/dev/null
echo "Terraform destroy complete. If k3s components remain, run infra/scripts/uninstall_k3s.sh if present."
