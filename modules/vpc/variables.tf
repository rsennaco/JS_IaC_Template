variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
}

variable "subnet_cidr" {
    type = string
    default = "10.0.1.0/24"
}

variable "az" {
    type = string
    default = "us-west-2a"
}

variable "route_cidr" {
    type = string
    default = "0.0.0.0/0"
}