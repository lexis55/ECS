resource "aws_ecs_cluster" "test-cluster" {
  name = "test-cluster"
}

resource "aws_ecs_cluster_capacity_providers" "test-cluster-cp" {
  cluster_name = aws_ecs_cluster.test-cluster.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

resource "aws_ecs_task_definition" "test-cluster-task" {
  family                   = "test-cluster"
  requires_compatibilities = [var.cluster-launch-type]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.test-task-execution-role.arn
  task_role_arn            = aws_iam_role.test-task-execution-role.arn


  #MAKE APPROPRIATE CHANGES TO CPU, MEMORY, AND PORT SETTINGS
  container_definitions = <<TASK_DEFINITION
[
  {
    "name": "test-container",
    "image": "${var.test-container-image}",
    "cpu": 256,
    "memory": 512,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ]
  }
]
TASK_DEFINITION

  runtime_platform {
    operating_system_family = var.operating_system_family
    cpu_architecture        = var.cpu_architecture
  }

  ephemeral_storage {
    size_in_gib = 50
  }
}

resource "aws_ecs_service" "test-cluster-service" {
  name                               = "test-cluster-service"
  cluster                            = aws_ecs_cluster.test-cluster.arn
  task_definition                    = aws_ecs_task_definition.test-cluster-task.arn
  force_new_deployment               = false
  desired_count                      = 1
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  enable_execute_command             = true

  deployment_circuit_breaker {
    enable   = true
    rollback = false
  }

  capacity_provider_strategy {
    base              = 1
    capacity_provider = var.cluster-launch-type
    weight            = 100
  }

  network_configuration {
    subnets          = [for s in data.aws_subnet.custom : s.id]
    security_groups  = [aws_security_group.test-sg.id]
    assign_public_ip = true
  }
}

resource "aws_security_group" "test-sg" {
  name   = "test-sg"
  vpc_id = data.aws_vpc.custom.id

  ingress {
    from_port   = var.test-port
    to_port     = var.test-port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_iam_policy_document" "test-task-execution-role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "test-task-execution-role" {
  name               = "test-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.test-task-execution-role.json
}

resource "aws_iam_role_policy_attachment" "test-task-execution-role" {
  role       = aws_iam_role.test-task-execution-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_vpc" "custom" {
  id = "vpc-095693c919a2d12fa"
}

data "aws_subnets" "custom" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.custom.id]
  }
}

data "aws_subnet" "custom" {
  for_each = toset(data.aws_subnets.custom.ids)
  id       = each.value
}
