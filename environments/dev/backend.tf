# ============================================================================
# Terraform Backend Configuration - Development Environment
# ============================================================================
# Configures S3 backend for storing Terraform state with DynamoDB locking.
#
# IMPORTANT: When using this template, replace the following:
# - bucket: Change "lex-platform-tfstate" to your project's bucket name
# - dynamodb_table: Change "lex-platform-tfstate-lock" to your table name
#
# Features:
# - State stored in S3 for team collaboration
# - DynamoDB table prevents concurrent modifications
# - Encryption enabled for security
# - Separate state file per environment

terraform {
  backend "s3" {
    bucket         = "lex-platform-tfstate"
    key            = "lex/dev/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "lex-platform-tfstate-lock"
    encrypt        = true
  }
}
