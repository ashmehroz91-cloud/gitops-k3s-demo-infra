terraform {
  required_version = ">= 1.0"
}

provider "local" {
}

resource "null_resource" "install_k3s" {
  provisioner "local-exec" {
    command = "bash ../scripts/install_k3s.sh ../kubeconfig.yaml"
    interpreter = ["/bin/bash", "-c"]
  }
}

resource "null_resource" "install_argocd" {
  depends_on = [null_resource.install_k3s]
  provisioner "local-exec" {
    command = "bash ../scripts/install_argocd.sh ../kubeconfig.yaml"
    interpreter = ["/bin/bash", "-c"]
  }
}
