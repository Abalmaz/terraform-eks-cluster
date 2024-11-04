# ALB Security Group
resource "aws_security_group" "alb" {
  name        = "${var.env_pref}-${var.name}-ecs-lb"
  description = "SG for ECS ALB"
  vpc_id      = var.vpc_id

  tags = {
    Name = "ecs-${var.name}-lb"
  }
}

resource "aws_security_group_rule" "http_from_world_to_alb" {
  description       = "HTTP Redirect ECS ALB"
  type              = "ingress"
  from_port         = var.app_port
  to_port           = var.app_port
  protocol          = "tcp"
  security_group_id = aws_security_group.alb.id
  cidr_blocks       = ["0.0.0.0/0"]
}


resource "aws_security_group_rule" "to_ecs_nodes" {
  description              = "Traffic to ECS Nodes"
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.alb.id
  source_security_group_id = aws_security_group.ecs_nodes.id
}

# ECS Security group
resource "aws_security_group" "ecs_nodes" {
  name        = "${var.env_pref}-${var.name}-ecs-nodes"
  description = "SG for ECS nodes"
  vpc_id      = var.vpc_id

  tags = {
    Name = "ecs-${var.name}-nodes"
  }
}

resource "aws_security_group_rule" "all_from_alb_to_ecs_nodes" {
  description              = "from ALB"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.ecs_nodes.id
  source_security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "ssh_from_vpn_to_ecs_nodes" {
  description       = "ssh from VPN"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs_nodes.id
}

resource "aws_security_group_rule" "all_from_ecs_nodes_to_ecs_nodes" {
  description              = "Traffic between ECS nodes"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.ecs_nodes.id
  source_security_group_id = aws_security_group.ecs_nodes.id
}

resource "aws_security_group_rule" "all_to_ecs_nodes" {
  description              = "Traffic to ECS Nodes"
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id        = aws_security_group.ecs_nodes.id
}