# variable "env" {
#     type = string
#     description = "Env to deploy to"
#     default = "dev"
# }

variable "image" {
    type = map
    description = "Image for container"
    default = {
        dev = "nodered/node-red:latest"
        prod = "nodered/node-red:latest-minimal"
    }
}

variable "ext_port" {
    type = map
    # sensitive = true
    
    validation {
        # condition = var.ext_port<=65535 && var.ext_port>=0
        condition = max(var.ext_port["dev"]...)<=65535 && min(var.ext_port["dev"]...)>=1980
        error_message = "The external port must be in the range 0-65535."
    }
    
     validation {
        condition = max(var.ext_port["prod"]...)<1980 && min(var.ext_port["prod"]...)>=1880 
        error_message = "The external port must be in the range 1880-1980."
    }
}

variable "int_port" {
    type = number
    default = 1880
    
    validation {
        condition = var.int_port == 1880
        error_message = "The internal port must be 1880."
    }
}

variable "c" {
    type = number
    default = 3
}

locals {
    # c_count = length(lookup(var.ext_port, var.env))
    # c_count = length(lookup(var.ext_port, terraform.workspace))
    c_count = length(var.ext_port[terraform.workspace])
}