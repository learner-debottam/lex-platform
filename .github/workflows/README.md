# GitHub Actions CI/CD Setup

## Overview
Automated Terraform deployment pipeline for Lex Platform across 4 environments: DEV → TEST → SIT → PROD

**Security:** Includes Checkov security scanning to validate infrastructure code against AWS best practices.

## Workflow Triggers
- **Pull Request**: Runs Checkov scan + `terraform plan` for all environments
- **Push to main**: Deploys sequentially to all environments after security validation

## Prerequisites

### 1. Create Environment Folders
Ensure these directories exist with Terraform configurations:
```
environments/
├── dev/
├── test/
├── sit/
└── prod/
```

### 2. Configure GitHub Secrets
Add these secrets in GitHub repository settings:

**AWS IAM Roles (using OIDC):**
- `AWS_ROLE_DEV` - IAM role ARN for DEV environment
- `AWS_ROLE_TEST` - IAM role ARN for TEST environment
- `AWS_ROLE_SIT` - IAM role ARN for SIT environment
- `AWS_ROLE_PROD` - IAM role ARN for PROD environment

### 3. Setup AWS OIDC Provider
Create OIDC provider in AWS IAM:
```bash
aws iam create-open-id-connect-provider \
  --url https://token.actions.githubusercontent.com \
  --client-id-list sts.amazonaws.com \
  --thumbprint-list 6938fd4d98bab03faadb97b34396831e3780aea1
```

### 4. Create IAM Roles
Example trust policy for GitHub Actions:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::ACCOUNT_ID:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        },
        "StringLike": {
          "token.actions.githubusercontent.com:sub": "repo:YOUR_ORG/lex-platform:*"
        }
      }
    }
  ]
}
```

Attach policy with Lex permissions:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "lex:*",
        "iam:PassRole",
        "iam:GetRole",
        "iam:CreateRole",
        "iam:AttachRolePolicy"
      ],
      "Resource": "*"
    }
  ]
}
```

### 5. Configure GitHub Environments
In GitHub repository settings → Environments, create:
- `dev` - **Required reviewers**: Add yourself or team (manual approval required)
- `test` - **Required reviewers**: Add yourself or team (manual approval required)
- `sit` - **Required reviewers**: Add yourself or team (manual approval required)
- `prod` - **Required reviewers**: Add designated production approvers (manual approval required)

**Important**: All environments now require manual approval. This allows you to:
1. Deploy to DEV
2. Test in DEV
3. Manually approve TEST deployment when ready
4. Test in TEST
5. Manually approve SIT deployment when ready
6. Test in SIT
7. Manually approve PROD deployment when ready

## Deployment Flow

### On Pull Request
1. **Checkov Security Scan**: Validates Terraform code against AWS security standards
2. Runs `terraform plan` for all 4 environments in parallel (only if security scan passes)
3. Uploads plans as artifacts
4. No deployment occurs

### On Push to Main
1. **Security Scan**: Validates code
2. **All environments available**: DEV, TEST, SIT, and PROD jobs are triggered but require manual approval
3. **Manual deployment flow**:
   - Deploy to DEV → Test → Approve TEST deployment
   - Deploy to TEST → Test → Approve SIT deployment
   - Deploy to SIT → Test → Approve PROD deployment
   - Deploy to PROD

**Note**: Each environment deployment is independent and requires manual approval through GitHub UI.

## Manual Deployment Process

1. **Push to main** - Triggers workflow
2. **Review DEV deployment** - Click "Review deployments" in Actions tab
3. **Approve DEV** - Deployment runs automatically
4. **Test in DEV** - Perform your testing
5. **Approve TEST** - When ready, approve TEST deployment from Actions tab
6. **Test in TEST** - Perform your testing
7. **Approve SIT** - When ready, approve SIT deployment
8. **Test in SIT** - Perform your testing
9. **Approve PROD** - Final approval for production deployment

## Security Scanning

### Checkov Integration
The pipeline includes automated security scanning using Checkov to detect:
- IAM misconfigurations
- Overly permissive policies
- Missing encryption
- Security group issues
- AWS best practice violations

### Configuration
Customize security checks in `.checkov.yml`:
- Skip specific checks not applicable to your use case
- Set severity threshold (LOW, MEDIUM, HIGH, CRITICAL)
- Enable/disable specific security policies

### Viewing Results
- Security findings appear in GitHub Security tab
- SARIF format results uploaded to GitHub Advanced Security
- Build fails if critical issues found (configurable via `soft-fail`)

## Backend Configuration
Ensure each environment has backend configuration in `backend.tf`:

```hcl
terraform {
  backend "s3" {
    bucket         = "lex-platform-tfstate-dev"
    key            = "terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "lex-platform-tfstate-lock"
    encrypt        = true
  }
}
```

## Monitoring
- View workflow runs: Actions tab in GitHub
- Check deployment status per environment
- Review Terraform plans in PR comments (if configured)

## Rollback
To rollback:
1. Revert the commit in main branch
2. Push to trigger new deployment
3. Or manually run `terraform apply` with previous state
