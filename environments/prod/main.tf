locals {
  bot_config = jsondecode(
    //file("${path.module}/../../bots/customer-support/bot.json")
    //file("${path.module}/../../bots/examples/booking-bot.json")
    //file("${path.module}/../../bots/examples/minimal-bot.json")
    //file("${path.module}/../../bots/examples/pizza-order-bot.json")
    file("${path.module}/../../bots/examples/restaurant-bot.json")
    //file("${path.module}/../../bots/examples/simple-greeting-bot.json")
  )
}

module "lex_bot" {
  source      = "../../modules/lex-bot"
  bot_config  = local.bot_config
  environment = "prod"

  tags = {
    Project     = "LexPlatform"
    Environment = "prod"
    Owner       = "PlatformTeam"
  }
}
