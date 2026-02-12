# 🚀 Quick Start Guide

This guide helps you set up your own AWS Lex bot project from this template.

## Step 1: Create Your Repository

1. Click **"Use this template"** button at the top of this repository
2. Name your new repository (e.g., `my-company-chatbots`)
3. Choose public or private
4. Click **"Create repository"**

## Step 2: Clone Your New Repository

```bash
git clone https://github.com/YOUR-USERNAME/YOUR-REPO-NAME.git
cd YOUR-REPO-NAME
```

## Step 3: Configure Git for Conventional Commits

```bash
git config commit.template .gitmessage
git config user.name "Your Name"
git config user.email "your.email@company.com"
```

## Step 4: Set Up AWS Infrastructure

### 4.1 Create S3 Bucket for Terraform State

```bash
aws s3api create-bucket \
  --bucket YOUR-PROJECT-tfstate \
  --region eu-west-2 \
  --create-bucket-configuration LocationConstraint=eu-west-2

aws s3api put-bucket-versioning \
  --bucket YOUR-PROJECT-tfstate \
  --versioning-configuration Status=Enabled

aws s3api put-bucket-encryption \
  --bucket YOUR-PROJECT-tfstate \
  --server-side-encryption-configuration '{
    "Rules": [{
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "AES256"
      }
    }]
  }'
```

### 4.2 Create DynamoDB Table for State Locking

```bash
aws dynamodb create-table \
  --table-name YOUR-PROJECT-tfstate-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region eu-west-2
```

### 4.3 Update Backend Configuration

Update `backend.tf` in each environment folder (`environments/dev/`, `environments/test/`, etc.):

```hcl
terraform {
  backend "s3" {
    bucket         = "YOUR-PROJECT-tfstate"
    key            = "lex/ENV/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "YOUR-PROJECT-tfstate-lock"
    encrypt        = true
  }
}
```

## Step 5: Set Up GitHub OIDC (Optional - for CI/CD)

### 5.1 Create OIDC Provider in AWS

```bash
aws iam create-open-id-connect-provider \
  --url https://token.actions.githubusercontent.com \
  --client-id-list sts.amazonaws.com \
  --thumbprint-list 6938fd4d98bab03faadb97b34396831e3780aea1
```

### 5.2 Create IAM Roles for Each Environment

Create a role for each environment (dev, test, sit, prod):

```bash
# Example for dev environment
aws iam create-role \
  --role-name GitHubActionsLexDev \
  --assume-role-policy-document '{
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::YOUR-ACCOUNT-ID:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        },
        "StringLike": {
          "token.actions.githubusercontent.com:sub": "repo:YOUR-USERNAME/YOUR-REPO:*"
        }
      }
    }]
  }'

# Attach necessary policies
aws iam attach-role-policy \
  --role-name GitHubActionsLexDev \
  --policy-arn arn:aws:iam::aws:policy/AmazonLexFullAccess
```

### 5.3 Add GitHub Secrets

Go to your repository → Settings → Secrets and variables → Actions:

- `AWS_ROLE_DEV`: `arn:aws:iam::YOUR-ACCOUNT-ID:role/GitHubActionsLexDev`
- `AWS_ROLE_TEST`: `arn:aws:iam::YOUR-ACCOUNT-ID:role/GitHubActionsLexTest`
- `AWS_ROLE_SIT`: `arn:aws:iam::YOUR-ACCOUNT-ID:role/GitHubActionsLexSit`
- `AWS_ROLE_PROD`: `arn:aws:iam::YOUR-ACCOUNT-ID:role/GitHubActionsLexProd`

## Step 6: Create Your First Bot

### 6.1 Create Bot Configuration

Create a new file in `bots/my-first-bot/bot.json`:

```json
{
  "name": "my-first-bot",
  "description": "My first Lex bot",
  "idle_session_ttl": 300,
  "locales": {
    "en_GB": {
      "description": "English locale",
      "confidence_threshold": 0.4,
      "intents": {
        "HelloIntent": {
          "description": "Greet user",
          "sample_utterances": ["Hello", "Hi", "Hey"]
        }
      }
    }
  }
}
```

### 6.2 Update Environment Configuration

Edit `environments/dev/main.tf`:

```hcl
locals {
  bot_config = jsondecode(
    file("${path.module}/../../bots/my-first-bot/bot.json")
  )
}
```

## Step 7: Deploy Your Bot

```bash
cd environments/dev
terraform init
terraform plan
terraform apply
```

## Step 8: Commit and Push

```bash
git add .
git commit -m "feat(bot): add my first bot"
git push origin main
```

## Next Steps

- ✅ Review [bot examples](bots/examples/) for more complex configurations
- ✅ Read [commit guidelines](COMMIT_GUIDELINES.md) for proper commit messages
- ✅ Check [CI/CD documentation](.github/workflows/README.md) for automation setup
- ✅ Customize tags in `main.tf` for your organization

## Troubleshooting

### Issue: Terraform state lock error
**Solution**: Ensure DynamoDB table exists and has correct permissions

### Issue: GitHub Actions failing
**Solution**: Verify OIDC provider and IAM roles are correctly configured

### Issue: Bot deployment fails
**Solution**: Check AWS Lex service limits and IAM permissions

## Support

- 📖 [AWS Lex Documentation](https://docs.aws.amazon.com/lexv2/)
- 📖 [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- 🐛 [Report Issues](../../issues)

---

**Happy Bot Building! 🤖**
