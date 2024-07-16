variable "app_name" {
    type = string
    default = "node-app"
}

variable "cluster_name" {
    type = string
    default = "node-cluster"
}

variable "ecs_role" {
    type = string
    default = "ecs_task_role"
}

variable "policy_arn" {
    type = string
    default = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskRolePolicy"
}

variable "cpu" {
    type = string
    default = "256"
}

variable "memory" {
    type = string
    default = "512"
}

variable "port" {
    type = string
    default = 3000
}