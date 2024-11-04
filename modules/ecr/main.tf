data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_ecr_repository" "ecr" {
  name                 = "${var.env_pref}-${var.name}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  provisioner "local-exec" {
    command = "./init_build.sh"
    working_dir = "${path.module}"
    environment = {
        IMAGE_TAG = var.image_tag
        ACCOUNT = data.aws_caller_identity.current.account_id
        REGION = data.aws_region.current.name
        REPO = self.name
    }
  }
}

locals {
  remove_old_image_rule = [{
    rulePriority = 1
    description  = "Rotate images when reach ${var.max_image_count} images stored",
    selection = {
      tagStatus   = "any"
      countType   = "imageCountMoreThan"
      countNumber = var.max_image_count
    }
    action = {
      type = "expire"
    }
  }]
}

resource "aws_ecr_lifecycle_policy" "name" {
  repository = aws_ecr_repository.ecr.name

  policy = jsonencode({
    rules = local.remove_old_image_rule
  })
}
