data "aws_ssm_parameter" "ecs_optimized_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended"
}

locals {
  user_data = <<-EOT
    #!/bin/bash
    echo ECS_CLUSTER=${var.env_pref}-${var.name}-cluster >> /etc/ecs/ecs.config;
  EOT
}

resource "aws_launch_template" "ecs_instance" {
  name_prefix   = "${var.env_pref}-${var.name}-"
  image_id      = jsondecode(data.aws_ssm_parameter.ecs_optimized_ami.value)["image_id"]
  instance_type = var.instance_type

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_instance.name
  }

  vpc_security_group_ids = [aws_security_group.ecs_nodes.id]

  user_data = base64encode(local.user_data)

  key_name = var.key_name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ecs" {
  name  = "${var.env_pref}-${var.name}-${var.instance_type}"
  vpc_zone_identifier = var.public_ips

  launch_template {
    id      = aws_launch_template.ecs_instance.id
    version = "$Latest"
  }

  min_size = var.min_size
  max_size = var.max_size
  desired_capacity          = var.desired_capacity
  health_check_type         = "EC2"

  tag {
    key                 = "Name"
    value               = "ecs-node-${var.name}"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}