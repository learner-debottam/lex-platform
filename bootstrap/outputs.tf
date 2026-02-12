output "oidc_provider_arn" {
  description = "ARN of the GitHub OIDC provider"
  value       = aws_iam_openid_connect_provider.github.arn
}

output "github_secrets" {
  description = "GitHub secrets to configure (copy these to GitHub repo settings)"
  value = {
    for env in local.environments :
    "AWS_ROLE_${upper(env)}" => aws_iam_role.github_actions[env].arn
  }
}

output "s3_bucket" {
  description = "S3 bucket for Terraform state"
  value       = aws_s3_bucket.tfstate.id
}

output "dynamodb_table" {
  description = "DynamoDB table for state locking"
  value       = aws_dynamodb_table.tfstate_lock.id
}

output "setup_instructions" {
  description = "Next steps"
  value       = <<-EOT
    
    ✅ Bootstrap Complete!
    
    📋 Next Steps:
    
    1. Add these secrets to GitHub (Settings → Secrets and variables → Actions):
       ${join("\n       ", [for k, v in {
    for env in local.environments :
    "AWS_ROLE_${upper(env)}" => aws_iam_role.github_actions[env].arn
  } : "${k} = ${v}"])}
    
    2. Update backend.tf in all environments with:
       bucket         = "${aws_s3_bucket.tfstate.id}"
       dynamodb_table = "${aws_dynamodb_table.tfstate_lock.id}"
    
    3. Run your bot deployments!
  EOT
}
