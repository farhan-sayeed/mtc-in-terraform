
resource "null_resource" "dockervol" {
	provisioner "local-exec" {
		command = "mkdir noderedvol/ || true && sudo chown -R 1000:1000 noderedvol/"
	}
}

module "image" {
	source = "./image"
	image_in = var.image[terraform.workspace]
}

resource "random_string" "random" {
		count = local.c_count
		length = 4
		special = false
		upper = false
}

# resource "random_string" "random_2" {
#     length = 4
#     special = false
#     upper = false
# }

module "container" {
		source = "./container"
		depends_on = [null_resource.dockervol]
		count = local.c_count
		# Implicit dependency
		# name = join("-",["nodered", terraform.workspace, null_resource.dockervol.id, random_string.random[count.index].result])
		 name_in = join("-",["nodered", terraform.workspace, random_string.random[count.index].result])
		# image = docker_image.nodered_image.latest
		image_in = module.image.image_out
		# ports {
		# 		internal = var.int_port
		# 		# external = lookup(var.ext_port, var.env)[count.index]
		# 		# external = lookup(var.ext_port, terraform.workspace)[count.index]
		# 		external = var.ext_port[terraform.workspace][count.index]
		# }
		int_port_in = var.int_port
		ext_port_in = var.ext_port[terraform.workspace][count.index]
		# volumes {
		# 	container_path = "/data"
		# 	host_path = "${path.cwd}/noderedvol"
		# }
		container_path_in = "/data"
		host_path_in = "${path.cwd}/noderedvol"
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