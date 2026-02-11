# Lex Platform - AWS Lex Bot Infrastructure

Terraform-based infrastructure for deploying AWS Lex V2 bots dynamically from JSON configurations.

## Features

- 🤖 Dynamic bot creation from JSON
- 🌍 Multi-locale support
- 🔒 Security scanning with Checkov
- 🚀 CI/CD with GitHub Actions
- 📝 Conventional commits enforcement
- 🔐 AWS OIDC authentication

## Project Structure

```
lex-platform/
├── modules/lex-bot/          # Reusable Terraform module
├── environments/             # Environment-specific configs
│   ├── dev/
│   ├── test/
│   ├── sit/
│   └── prod/
├── bots/                     # Bot JSON configurations
│   ├── customer-support/
│   └── examples/
└── .github/workflows/        # CI/CD pipelines
```

## Quick Start

### 1. Clone Repository
```bash
git clone <repository-url>
cd lex-platform
```

### 2. Configure Git
```bash
# Set commit template for conventional commits
git config commit.template .gitmessage

# Set your identity
git config user.name "Your Name"
git config user.email "your.email@example.com"
```

### 3. Create Bot Configuration
Create a JSON file in `bots/` directory:
```json
{
  "name": "my-bot",
  "description": "My custom bot",
  "idle_session_ttl": 300,
  "locales": {
    "en_GB": {
      "description": "English locale",
      "confidence_threshold": 0.4,
      "intents": {
        "HelloIntent": {
          "description": "Greet user",
          "sample_utterances": ["Hello", "Hi"]
        }
      }
    }
  }
}
```

### 4. Deploy
```bash
cd environments/dev
terraform init
terraform plan
terraform apply
```

## Commit Guidelines

Follow Conventional Commits format:
```
feat(bot): add new finance bot
fix(slots): correct slot type reference
docs(readme): update deployment steps
```

See [COMMIT_GUIDELINES.md](COMMIT_GUIDELINES.md) for details.

## CI/CD Pipeline

- **PR**: Security scan + Terraform plan for all environments
- **Push to main**: Manual approval required for each environment deployment

See [.github/workflows/README.md](.github/workflows/README.md) for setup.

## Security

- ✅ Checkov security scanning
- ✅ AWS OIDC authentication (no access keys)
- ✅ Secrets excluded via .gitignore
- ✅ Environment-based approvals

## Documentation

- [Commit Guidelines](COMMIT_GUIDELINES.md)
- [CI/CD Setup](.github/workflows/README.md)
- [Bot Examples](bots/examples/)

## License

[Your License]
