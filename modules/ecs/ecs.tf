resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.env_pref}-${var.name}-cluster"
  tags = {
    Name        = "${var.name}-ecs"
    Environment = var.env_pref
  }
}

# Create Logs
resource "aws_cloudwatch_log_group" "log-group" {
  name = "${var.env_pref}-${var.name}-logs"
  retention_in_days = var.log_retention_in_days

  tags = {
    Application = var.name
    Environment = var.env_pref
  }
}

resource "aws_cloudwatch_log_stream" "log-stream" {
  name           = "${var.env_pref}-${var.name}-log-stream"
  log_group_name = aws_cloudwatch_log_group.log-group.name
}


# Create Task Definition
data "template_file" "app" {
  template = file("${path.module}/templates/myapp.json.tpl")

  vars = {
    name = "${var.env_pref}-${var.name}"
    docker_image_url = "${var.repository_url}:${var.image_tag}"
  }
}

resource "aws_ecs_task_definition" "task_definition" {
  family                = "${var.env_pref}-${var.name}"
  task_role_arn = aws_iam_role.ecs_task.arn
  execution_role_arn = aws_iam_role.ecs_task.arn
  container_definitions = data.template_file.app.rendered
  memory = 512
  requires_compatibilities = ["EC2"]
  network_mode = "bridge"
  cpu = 1024
}

# Create Service
resource "aws_ecs_service" "worker" {
  name            = "${var.env_pref}-${var.name}-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  iam_role        = aws_iam_role.ecs_service.arn
  desired_count   = var.app_count
  depends_on      = [aws_iam_role_policy.ecs_service_role_policy]

  load_balancer {
    target_group_arn = aws_alb_target_group.alb_target_group.arn
    container_name   = "${var.env_pref}-${var.name}"
    container_port = 80
  }
}