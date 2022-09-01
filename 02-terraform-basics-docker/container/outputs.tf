output "container-name" {
    value = docker_container.nodered_container.name
    description = "Name of the container"
}

#IP address & port using for loop
output "container-ip-address" {
    value = [for i in docker_container.nodered_container[*]:join(":",[i.ip_address],i.ports[*]["external"])]
    description = "IP address & external port of the container"
    # sensitive = true
}