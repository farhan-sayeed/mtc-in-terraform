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
    count = 1
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
    count = 1
    name = join("-",["nodered", random_string.random[count.index].result])
    image = docker_image.nodered_image.latest
    ports {
        internal = 1880
        #external = 1880
    }
}

resource "docker_container" "nodered_container2" {
    name = "nodered-tgsl"
    image = "docker_image.nodered_image.latest"
}

# For importing terraform container
# terraform import docker_container.nodered_container $(docker inspect --format="{{.ID}}" nodered-3kki)
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

# output "container-name-1" {
#     value = docker_container.nodered_container[0].name
#     description = "Name of the container"
# }

output "container-name" {
    value = docker_container.nodered_container[*].name
    description = "Name of the container"
}

# output "container-ip_address-1" {
#     value = join (":", [docker_container.nodered_container[0].ip_address, docker_container.nodered_container[0].ports[0].external])
#     description = "IP address & external port of the container"
# }

# output "container-name-2" {
#     value = docker_container.nodered_container[1].name
#     description = "Name of the container"
# }

# output "container-ip_address-2" {
#     value = join (":", [docker_container.nodered_container[1].ip_address, docker_container.nodered_container[1].ports[0].external])
#     description = "IP address & external port of the container"
# }
#IP address & port using for loop
output "container-ip-address" {
    value = [for i in docker_container.nodered_container[*]:join(":",[i.ip_address],i.ports[*]["external"])]
    description = "IP address & external port of the container"
}