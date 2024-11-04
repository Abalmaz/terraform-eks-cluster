# ECS Role
resource "aws_iam_role" "ecs_instance" {
  name               = "${var.env_pref}-${var.name}-ecs-instance-role"
  assume_role_policy = file("${path.module}/policies/ecs-instance-role.json")
}

resource "aws_iam_instance_profile" "ecs_instance" {
  name = "${var.env_pref}-${var.name}-ecs-instance-profile"
  role = aws_iam_role.ecs_instance.name
}

resource "aws_iam_role_policy_attachment" "ecs_ec2" {
  role       = aws_iam_role.ecs_instance.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

# ECS Service Role
resource "aws_iam_role" "ecs_service" {
  name = "${var.env_pref}-${var.name}-ecs-service"
  assume_role_policy = file("${path.module}/policies/ecs-role.json")
}

resource "aws_iam_role_policy" "ecs_service_role_policy" {
  name   = "${var.env_pref}-${var.name}-ecs-service-role-policy"
  policy = file("${path.module}/policies/ecs-service-role-policy.json")
  role   = aws_iam_role.ecs_service.id
}

# ECS Task Role
resource "aws_iam_role" "ecs_task" {
  name = "${var.env_pref}-${var.name}-ecs-task"
  assume_role_policy = file("${path.module}/policies/ecs-task-role-policy.json")
}

resource "aws_iam_role_policy_attachment" "ecs_task" {
  role       = aws_iam_role.ecs_task.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}