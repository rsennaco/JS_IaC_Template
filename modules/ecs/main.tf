# ECS Repository config
resource "aws_ecr_repository" "node_app" {
    name = var.app_name
}

# ECS Cluster config
resource "aws_ecs_cluster" "node_cluster" {
    name = var.cluster_name
}

# IAM Role config
resource "aws_iam_role" "ecs_task_role" {
    name = var.ecs_role

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Principle = {
                    Service = "ecs-tasks.amazonaws.com"
                }
                Action = "sts:AssumeRole"
            }
        ]
    })

    managed_policy_arns = [
        var.policy_arn,
    ]
}

# ECS Task config
resource "aws_ecs_task_definition" "node_task" {
    family = "node-task"
    network_mode = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu = var.cpu
    memory = var.memory

    container_definitions = jsonencode([
        {
            name = var.app_name
            image = "${aws_ecr_repository.node_app.repository_url}:latest"
            essential = true
            portMappings = [
                {
                    containerPort = var.port
                    hostPort = var.port
                }
            ]
        }
    ])

    execution_role_arn = aws_iam_role.ecs_task_role.arn
    task_role_arn = aws_iam_role.ecs_task_role.arn

    depends_on = [ aws_iam_role.ecs_task_role ]
}

# ECS Service config
resource "aws_ecs_service" "node_service" {
    name = "node-service"
    cluster = aws_ecs_cluster.node_cluster.id
    task_definition = aws_ecs_task_definition.node_task.arn
    desired_count = 1
    launch_type = "FARGATE"

    network_configuration {
      subnets = [aws_subnet.public.id]
      security_groups = [aws_security_group.node_sg.id]
      assign_public_ip = true
    }

    depends_on = [ aws_ecs_task_definition.node_task ]
}

# Load Balancer config
resource "aws_lb" "node_lb" {
    name = "node-lb"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.node_sg.id]
    subnets = [aws_subnet.public.id]

    enable_deletion_protection = false
}

# Target Group config
resource "aws_lb_target_group" "node_tg" {
    name = "node-tg"
    port = var.port
    protocol = "HTTP"
    vpc_id = aws_vpc.main.id
}

# Listener config
resource "aws_lb_listener" "node_listener" {
    load_balancer_arn = aws_lb.node_lb.arn
    port = "80"
    protocol = "HTTP"

    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.node_tg.arn
    }
}

# Security Group config 
resource "aws_security_group" "node_sg" {
    vpc_id = aws_vpc.main.id

    ingress {
        from_port = var.port
        to_port = var.port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "node-sg"
    }
}