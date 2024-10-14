terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "= 3.0.2"
    }
  }
}

provider "docker" {
  host = var.docker_host
}

data "docker_network" "organize_me" {
  name = var.docker_network
}
