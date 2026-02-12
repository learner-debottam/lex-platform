resource "aws_kms_key" "tfstate" {
  description             = "KMS key for Terraform state and lock table"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  tags = {
    Name    = "${var.project_name}-tfstate-kms"
    Project = var.project_name
  }
}

resource "aws_kms_alias" "tfstate" {
  name          = "alias/${var.project_name}-tfstate"
  target_key_id = aws_kms_key.tfstate.key_id
}