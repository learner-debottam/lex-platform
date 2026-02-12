# ============================================================================
# AWS Provider Configuration - Development Environment
# ============================================================================
# Configures the AWS provider for the eu-west-2 (London) region.
#
# To change region:
# 1. Update the region value below
# 2. Update the region in backend.tf
# 3. Ensure your AWS credentials have access to the new region

provider "aws" {
  region = "eu-west-2"
}