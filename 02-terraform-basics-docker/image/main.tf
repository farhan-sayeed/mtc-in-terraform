resource "docker_image" "nodered_image" {
		name = var.image_in
		# name = "nodered/node-red:latest"
		# name = lookup(var.image, var.env)
		# name = lookup(var.image, terraform.workspace)
		# name = var.image[terraform.workspace]
}