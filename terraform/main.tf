terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "= 3.0.1"
    }
  }
}

provider "docker" {
}

data "docker_network" "organize_me" {
  name = "organize_me_network"
}
