terraform {
  required_providers {
    docker = {
      source  = "terraform-providers/docker"
      version = "~> 2.7.2"
    }
  }
}

provider "docker" {}

resource "null_resource" "dockervol" {
  provisioner "local-exec" {
    command = "mkdir noderedvol/ || true && sudo chown -R 1000:1000 noderedvol/"
  }
}

resource "docker_image" "nodered_image" {
    name = "nodered/node-red:latest"
}

resource "random_string" "random" {
    count = var.c
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
    count = local.c_count
    name = join("-",["nodered", random_string.random[count.index].result])
    image = docker_image.nodered_image.latest
    ports {
        internal = var.int_port
        external = var.ext_port[count.index]
    }
    volumes {
      container_path = "/data"
      host_path = "${path.cwd}/noderedvol"
    }
}

# resource "docker_container" "nodered_container2" {
#     name = "nodered-tgsl"
#     image = "docker_image.nodered_image.latest"
# }

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