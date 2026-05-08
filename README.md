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

# ArgoCD CLI (optional)
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64
argocd version --client
```

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

## Deploy the app later

Once the cluster is ready, use the manifests repo to deploy the demo app:

Hint: this demo uses DockerHub images under username `ashmehroz1`.

```bash
## You have run these commands in your root directory :--> gitops-k3s-demo-manifests-
export KUBECONFIG="../gitops-k3s-demo-infra/infra/kubeconfig.yaml"
helm upgrade --install gitops-app charts/app -n default --create-namespace -f charts/app/values.yaml
```

## Access ArgoCD dashboard

```bash
## You have run these commands in your root directory :--> gitops-k3s-demo-infra
kubectl port-forward svc/argocd-server -n argocd 8081:443
```

Then open:

```text
https://localhost:8081
```

Username: `admin`

Get the password with: Yu5bdm2v8Dqubgwi


```bash
## You have run these commands in your root directory :--> gitops-k3s-demo-infra
export KUBECONFIG="infra/kubeconfig.yaml"
kubectl --kubeconfig="$KUBECONFIG" cluster-info
kubectl --kubeconfig="$KUBECONFIG" get ns
```

## Stop access to the dashboard

If you started a port-forward, stop it with `Ctrl+C` or kill the process:

```bash
## You have run these commands in your root directory :--> gitops-k3s-demo-infra
pkill -f "kubectl port-forward" || true
```

## Destroy

```bash
## You have run these commands in your root directory :--> gitops-k3s-demo-infra
./scripts/down.sh
```

## Full stop order

For a clean shutdown:

1. Stop any `kubectl port-forward` sessions.
2. Uninstall the app from the manifests repo if it is deployed with Helm or ArgoCD.
3. Run `./scripts/down.sh`.
4. If needed, remove k3s with the host uninstall script.
