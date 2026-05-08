# gitops-k3s-demo-infra

This repo provisions a local single-node k3s cluster and installs ArgoCD.

## Readme order (follow first)

This is step 1 of 3.

1. `gitops-k3s-demo-infra` (this repo): create k3s cluster and ArgoCD
2. `gitops-k3s-demo-app`: build/push/import app images
3. `gitops-k3s-demo-manifests-`: deploy app with Helm/ArgoCD

## What this repo is for

The client clones this repo to create and destroy the Kubernetes layer locally.

## Supported environments

- Linux: supported directly
- Windows: use a Linux VM for the actual install and cluster commands
- macOS: use a Linux VM for the actual install and cluster commands

This repo installs k3s on a Linux host, so native Windows/macOS shells are not enough on their own. The k3s scripts run inside the Linux VM.

## Prerequisites and installation commands
- Vs Code
- Git (check first: `git --version`)
- Terraform 1.0+ (check first: `terraform -version`)
- kubectl (check first: `kubectl version --client`)
- Helm 3 (optional, check first: `helm version`)
- ArgoCD CLI (optional, check first: `argocd version --client`)
- sudo access

```bash
sudo apt update
sudo apt install -y git curl ca-certificates gnupg lsb-release unzip apt-transport-https

# Terraform
sudo apt update && sudo apt install -y gnupg software-properties-common curl
  curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
   echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update
   sudo apt install terraform
   if not install with apt use snap :    sudo snapminstall terraform --classic
   terraform -version
  terraform -install-autocomplete
 sudo apt update && sudo apt upgrade terraform


# kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl
kubectl version --client

# Helm (optional)
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
helm version



The k3s installation from this repo must run on Linux, so Windows and macOS users should run commands inside the Linux VM.

## Quick start

```bash
## You have run these commands in your root directory :--> gitops-k3s-demo-infra
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
## You have run these commands in your root directory :--> gitops-k3s-demo-infra
export KUBECONFIG="infra/kubeconfig.yaml"
kubectl get nodes
kubectl get pods -n argocd
```




```bash
## You have run these commands in your root directory :--> gitops-k3s-demo-infra
export KUBECONFIG="infra/kubeconfig.yaml"
kubectl --kubeconfig="$KUBECONFIG" cluster-info
kubectl --kubeconfig="$KUBECONFIG" get ns
```


## Destroy

```bash
## You have run these commands in your root directory :--> gitops-k3s-demo-infra
./scripts/down.sh
```

