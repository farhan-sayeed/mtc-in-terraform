# output "container-ip-address" {
#     value = docker_container.nodered_container.ip_address
#     description = "IP address of the container "
# }

# output "container-name-1" {
#     value = docker_container.nodered_container[0].name
#     description = "Name of the container"
# }

output "container-name" {
    value = module.container[*].container-name
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
# IP address & port using for loop
output "container-ip-address" {
    value = flatten(module.container[*].container-ip-address)
    description = "IP address & external port of the container"
    # sensitive = true
}