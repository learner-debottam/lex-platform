# Template Setup Checklist

Use this checklist when setting up your project from this template.

## Initial Setup

- [ ] Click "Use this template" to create your repository
- [ ] Clone your new repository locally
- [ ] Configure git with commit template: `git config commit.template .gitmessage`
- [ ] Update this README with your project name

## AWS Infrastructure

- [ ] Create S3 bucket for Terraform state (replace `lex-platform-tfstate`)
- [ ] Enable versioning on S3 bucket
- [ ] Enable encryption on S3 bucket
- [ ] Create DynamoDB table for state locking (replace `lex-platform-tfstate-lock`)
- [ ] Update `backend.tf` in all environment folders with your bucket/table names

## GitHub Configuration (Optional - for CI/CD)

- [ ] Create AWS OIDC provider in your AWS account
- [ ] Create IAM roles for each environment (dev, test, sit, prod)
- [ ] Attach necessary IAM policies to roles (Lex, S3, DynamoDB)
- [ ] Add GitHub secrets for AWS role ARNs
- [ ] Configure GitHub environments with protection rules

## Customization

- [ ] Update tags in `environments/*/main.tf` with your organization details
- [ ] Review and update `.checkov.yml` security rules
- [ ] Customize workflow triggers in `.github/workflows/terraform-deploy.yml`
- [ ] Remove example bots you don't need from `bots/examples/`
- [ ] Create your first bot configuration in `bots/`

## Testing

- [ ] Run `terraform init` in dev environment
- [ ] Run `terraform plan` to verify configuration
- [ ] Deploy to dev: `terraform apply`
- [ ] Test bot in AWS Lex console
- [ ] Verify CI/CD pipeline runs successfully

## Documentation

- [ ] Update README.md with your project details
- [ ] Document your bot configurations
- [ ] Add team-specific setup instructions
- [ ] Update license information

## Cleanup

- [ ] Delete this checklist file once setup is complete
- [ ] Remove unused example bots
- [ ] Archive or delete template-specific documentation

---

**Once complete, delete this file and start building your bots! 🚀**
