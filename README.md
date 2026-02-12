# Lex Platform - AWS Lex Bot Infrastructure Template

[![Use this template](https://img.shields.io/badge/Use%20this%20template-2ea44f?style=for-the-badge)](../../generate)
[![Terraform](https://img.shields.io/badge/Terraform-1.6+-623CE4?style=flat-square&logo=terraform)](https://www.terraform.io/)
[![AWS Lex](https://img.shields.io/badge/AWS%20Lex-V2-FF9900?style=flat-square&logo=amazon-aws)](https://aws.amazon.com/lex/)

> **🚀 GitHub Template Repository** - Click "Use this template" to create your own AWS Lex bot infrastructure project!

Terraform-based infrastructure template for deploying AWS Lex V2 bots dynamically from JSON configurations. Perfect for teams building conversational AI applications.

## ✨ Why Use This Template?

- 🎯 **Zero to Bot in Minutes** - Pre-configured infrastructure ready to deploy
- 📦 **Reusable Module** - One module, multiple bots across environments
- 🔒 **Security First** - Built-in Checkov scanning and AWS best practices
- 🚀 **CI/CD Ready** - GitHub Actions workflows included
- 📚 **Rich Examples** - 6+ industry-specific bot templates (restaurant, ecommerce, insurance, etc.)
- 🌍 **Multi-locale Support** - Deploy bots in multiple languages

## 🚀 Quick Start

### 1️⃣ Use This Template

Click the **"Use this template"** button above or [click here](../../generate)

### 2️⃣ Clone Your New Repository

```bash
git clone https://github.com/YOUR-USERNAME/YOUR-REPO-NAME.git
cd YOUR-REPO-NAME
```

### 3️⃣ Follow the Setup Guide

See [QUICKSTART.md](QUICKSTART.md) for detailed setup instructions including:
- AWS infrastructure setup (S3, DynamoDB)
- GitHub OIDC configuration
- Creating your first bot
- Deploying to AWS

## 📋 What's Included

- 🤖 Dynamic bot creation from JSON
- 🌍 Multi-locale support
- 🔒 Security scanning with Checkov
- 🚀 CI/CD with GitHub Actions
- 📝 Conventional commits enforcement
- 🔐 AWS OIDC authentication

## 📁 Project Structure

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

## 🎯 Bot Examples

The template includes ready-to-use bot configurations:

- **restaurant-bot** - Table reservations and menu inquiries
- **ecommerce-bot** - Order tracking and returns
- **utilities-bot** - Bill payments and outage reporting  
- **insurance-bot** - Claims filing and policy management
- **customer-support** - General customer service
- And more in `bots/examples/`

## 🛠️ Usage

### Deploy a Bot

```bash
cd environments/dev
terraform init
terraform plan
terraform apply
```

### Switch Between Bots

Edit `environments/ENV/main.tf` and change the bot file:

```hcl
locals {
  bot_config = jsondecode(
    file("${path.module}/../../bots/YOUR-BOT/bot.json")
  )
}
```

## 🎨 Customization

### Create Your Own Bot

Create `bots/my-bot/bot.json`:

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

### Update Backend Configuration

Replace `lex-platform-tfstate` with your bucket name in `environments/*/backend.tf`:

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

## 📝 Commit Guidelines

Follow Conventional Commits format:
```
feat(bot): add new finance bot
fix(slots): correct slot type reference
docs(readme): update deployment steps
```

See [COMMIT_GUIDELINES.md](COMMIT_GUIDELINES.md) for details.

## 🔄 CI/CD Pipeline

- **PR**: Security scan + Terraform plan for all environments
- **Push to main**: Manual approval required for each environment deployment

See [.github/workflows/README.md](.github/workflows/README.md) for setup.

## 🔒 Security

- ✅ Checkov security scanning
- ✅ AWS OIDC authentication (no access keys)
- ✅ Secrets excluded via .gitignore
- ✅ Environment-based approvals

## 📚 Documentation

- **[Quick Start Guide](QUICKSTART.md)** - Complete setup instructions
- **[Commit Guidelines](COMMIT_GUIDELINES.md)** - How to write proper commits
- **[CI/CD Setup](.github/workflows/README.md)** - GitHub Actions configuration
- **[Bot Examples](bots/examples/)** - Sample bot configurations

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Follow conventional commits
4. Submit a pull request

## 📄 License

MIT License - feel free to use this template for your projects!

## 🆘 Support

- 📖 [AWS Lex Documentation](https://docs.aws.amazon.com/lexv2/)
- 📖 [Terraform Documentation](https://www.terraform.io/docs)
- 🐛 [Report Issues](../../issues)
- 💬 [Discussions](../../discussions)

---

**Made with ❤️ for the AWS community**
