module "lex_bot" {
  source = "../modules/lex-bot"
  bot_config = local.bot_config
  environment = var.environment
  tags = local.tags
}