# gitops-k3s-demo-infra

This repo provisions a local k3s single-node cluster and installs ArgoCD.

Quick scripted flow (recommended):

```bash
cd /home/usman/Desktop/gitops-k3s-demo-infra
chmod +x scripts/*.sh infra/scripts/*.sh
./scripts/up.sh
```

Manual Terraform flow (if you prefer to run Terraform yourself):

```bash
cd infra/terraform
terraform init
terraform plan
terraform apply -auto-approve
terraform output -raw kubeconfig_path
export KUBECONFIG=$(terraform output -raw kubeconfig_path)
# then install ArgoCD manually if desired:
kubectl create namespace argocd || true
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

Teardown:

```bash
cd /home/usman/Desktop/gitops-k3s-demo-infra
./scripts/down.sh
```
# gitops-k3s-demo-infra
Terraform and provisioning scripts to create/destroy the k3s cluster and install ArgoCD.
