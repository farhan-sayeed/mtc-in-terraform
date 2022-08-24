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

resource "random_string" "random" {
    count = 2
    length = 4
    special = false
    upper = false
}

# resource "random_string" "random_2" {
#     length = 4
#     special = false
#     upper = false
# }

resource "docker_container" "nodered_container" {
    count = 2
    name = join("-",["nodered", random_string.random[count.index].result])
    image = docker_image.nodered_image.latest
    ports {
        internal = 1880
        #external = 1880
    }
}


# resource "docker_container" "nodered_container_2" {
#     name = join("-",["nodered", random_string.random_2.result])
#     image = docker_image.nodered_image.latest
#     ports {
#         internal = 1880
#         #external = 1880
#     }
# }
# output "container-ip-address" {
#     value = docker_container.nodered_container.ip_address
#     description = "IP address of the container "
# }

output "container-name-1" {
    value = docker_container.nodered_container[0].name
    description = "Name of the container"
}

output "container-ip_address-1" {
    value = join (":", [docker_container.nodered_container[0].ip_address, docker_container.nodered_container[0].ports[0].external])
    description = "IP address & external port of the container"
}

output "container-name-2" {
    value = docker_container.nodered_container[1].name
    description = "Name of the container"
}

output "container-ip_address-2" {
    value = join (":", [docker_container.nodered_container[1].ip_address, docker_container.nodered_container[1].ports[0].external])
    description = "IP address & external port of the container"
}