terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.18.1"
    }

    # Terraform 'docker' provider...
    # The kreuzwerker 'docker' provider seems to be the most used provider
    # https://registry.terraform.io/search/providers?q=docker
    # https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.1"
    }
  }
}

provider "kubernetes" {
  # adjust the config settings based on your k8s setup
  config_path    = "~/.kube/config"
  config_context = "docker-desktop"
}

provider "docker" {}