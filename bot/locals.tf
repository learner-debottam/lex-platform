locals {
  bot_config = jsonencode(
    file("${path.module}/examples/pizza-order-bot.json")
  )
  tags ={
    Application = "My-Bot"
    ManagedBy ="Terraform"
    Evironment = var.environment
    environment = "dev"
aws_region = var.aws_region
aws_account_name = var.aws_account_name
aws_account_id = var.aws_account_id
  }
  
}