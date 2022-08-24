terraform {
  required_providers {
    docker = {
      source  = "terraform-providers/docker"
      version = "~> 2.7.2"
    }
  }
}

provider "docker" {}

resource "docker_image" "nodered_image" {
    name = "nodered/node-red:latest"
}

resource "docker_container" "nodered_container" {
    name = "nodered"
    image = docker_image.nodered_image.latest
    ports {
        internal = 1880
        external = 1880
    }
}

output "container-ip-address" {
    value = docker_container.nodered_container.ip_address
    description = "IP address of the container "
}

output "container-name" {
    value = docker_container.nodered_container.name
    description = "Name of the container"
}