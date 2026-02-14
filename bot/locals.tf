locals {
  bot_config = jsonencode(
    file("${path.module}/examples/pizza-order-bot.json")
  )
  tags ={
    Application = "My-Bot"
    ManagedBy ="Terraform"
    Evironment = var.environment
  }
}