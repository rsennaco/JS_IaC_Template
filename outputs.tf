output "ecr_repository_url" {
    value = module.ecs.ecr_repository_url
}

output "ecs_cluster_id" {
    value = module.ecs.ecs_cluster_id
}

output "service_name" {
    value = module.ecs.service_name
}

output "load_balancer_dns" {
    value = module.ecs.load_balancer_dns
}

output "vpc_id" {
    value = module.vpc.vpc_id
}

output "subnet_id" {
    value = module.vpc.public_subnet_id
}