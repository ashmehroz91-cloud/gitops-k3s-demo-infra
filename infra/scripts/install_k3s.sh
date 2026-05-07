#!/usr/bin/env bash
set -euo pipefail
OUT_KUBECONFIG="${1:-./kubeconfig.yaml}"

if command -v k3s >/dev/null 2>&1 && kubectl --kubeconfig "$OUT_KUBECONFIG" get nodes >/dev/null 2>&1; then
  echo "k3s already installed and kubeconfig works: $OUT_KUBECONFIG"
  exit 0
fi

echo "Installing k3s (local single-node)..."
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--write-kubeconfig-mode=644" sh -
sudo cp /etc/rancher/k3s/k3s.yaml "$OUT_KUBECONFIG"
sudo chown $(id -u):$(id -g) "$OUT_KUBECONFIG" || true
echo "Wrote kubeconfig to $OUT_KUBECONFIG"
