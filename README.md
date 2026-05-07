# gitops-k3s-demo-infra

This repo provisions a local single-node k3s cluster and installs ArgoCD.

## What this repo is for

The client clones this repo to create and destroy the Kubernetes layer locally.

## Tools to install

Required:
- Git
- Terraform 1.0+
- kubectl
- k3s
- sudo access on the laptop

Optional:
- Helm 3
- ArgoCD CLI

## Quick start

```bash
cd /path/to/gitops-k3s-demo-infra
chmod +x scripts/*.sh infra/scripts/*.sh
./scripts/up.sh
```

This will:
- run Terraform
- install k3s
- write the kubeconfig
- install ArgoCD

## Check the cluster

```bash
export KUBECONFIG="/path/to/gitops-k3s-demo-infra/infra/kubeconfig.yaml"
kubectl get nodes
kubectl get pods -n argocd
```

## Access ArgoCD dashboard

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Then open:

```text
https://localhost:8080
```

Username: `admin`

Get the password with:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d; echo
```

## Destroy

```bash
cd /path/to/gitops-k3s-demo-infra
./scripts/down.sh
```
