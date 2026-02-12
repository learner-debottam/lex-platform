# Bootstrap Infrastructure Setup

This Terraform project automates the setup of AWS infrastructure required for the Lex Platform CI/CD pipeline.

## What It Creates

- ✅ GitHub OIDC Provider in AWS
- ✅ IAM Roles for each environment (dev, test, sit, prod)
- ✅ S3 bucket for Terraform state
- ✅ DynamoDB table for state locking

## Prerequisites

- AWS CLI configured with admin credentials
- Terraform 1.6.0 or later
- Your GitHub repository name (format: `owner/repo`)

## Usage

### 1. Initialize and Apply

```bash
cd bootstrap

# Initialize Terraform
terraform init

# Review the plan
terraform plan -var="github_repo=YOUR-USERNAME/YOUR-REPO"

# Apply (creates all resources)
terraform apply -var="github_repo=YOUR-USERNAME/YOUR-REPO"
```

### 2. Copy GitHub Secrets

After `terraform apply`, you'll see output like:

```
github_secrets = {
  "AWS_ROLE_DEV" = "arn:aws:iam::123456789012:role/GitHubActionsLexDev"
  "AWS_ROLE_TEST" = "arn:aws:iam::123456789012:role/GitHubActionsLexTest"
  ...
}
```

Add these to GitHub:
1. Go to your repo → **Settings** → **Secrets and variables** → **Actions**
2. Click **New repository secret**
3. Add each secret with the name and ARN value

### 3. Update Backend Configuration

Update `backend.tf` in each environment folder (`environments/dev/`, `environments/test/`, etc.):

```hcl
terraform {
  backend "s3" {
    bucket         = "OUTPUT_S3_BUCKET_NAME"
    key            = "lex/ENV/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "OUTPUT_DYNAMODB_TABLE_NAME"
    encrypt        = true
  }
}
```

### 4. You're Ready!

Your CI/CD pipeline is now configured. Push to `main` to trigger deployments.

## Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `github_repo` | GitHub repository (owner/repo) | **Required** |
| `aws_region` | AWS region | `eu-west-2` |
| `project_name` | Project name for resources | `lex-platform` |

## Example with Custom Values

```bash
terraform apply \
  -var="github_repo=mycompany/chatbots" \
  -var="project_name=mycompany-lex" \
  -var="aws_region=us-east-1"
```

## Cleanup

To remove all bootstrap resources:

```bash
terraform destroy -var="github_repo=YOUR-USERNAME/YOUR-REPO"
```

⚠️ **Warning:** This will delete the OIDC provider, IAM roles, S3 bucket, and DynamoDB table.

## Troubleshooting

### Error: OIDC provider already exists

If you see this error, the OIDC provider already exists. You can either:
1. Import it: `terraform import aws_iam_openid_connect_provider.github arn:aws:iam::ACCOUNT:oidc-provider/token.actions.githubusercontent.com`
2. Or remove it from AWS and re-run

### Error: Role already exists

Similar to above, import existing roles or delete them first.

## Security Notes

- Roles use OIDC (no long-lived credentials)
- S3 bucket has versioning and encryption enabled
- Public access to S3 bucket is blocked
- Each environment has a separate IAM role
