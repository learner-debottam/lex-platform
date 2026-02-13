# ============================================================================
# Development Environment - Lex Bot Configuration
# ============================================================================
# This file deploys a Lex bot to the DEV environment.
#
# To switch bots:
# 1. Comment out the current file() line
# 2. Uncomment the desired bot configuration
# 3. Run: terraform plan && terraform apply
#
# Available bots:
# - customer-support: General customer service bot
# - booking-bot: Appointment/reservation booking
# - minimal-bot: Simple example with one intent
# - pizza-order-bot: Food ordering example
# - restaurant-bot: Restaurant reservations and menu
# - simple-greeting-bot: Basic greeting bot
# - ecommerce-bot: Order tracking and returns
# - utilities-bot: Bill payments and outages
# - insurance-bot: Claims and policy management

locals {
  bot_config = jsondecode(
    //file("${path.module}/../../bots/customer-support/bot.json")
   // file("${path.module}/../../bots/examples/booking-bot.json"),
    //file("${path.module}/../../bots/examples/minimal-bot.json")
    file("${path.module}/../../bots/examples/pizza-order-bot.json"),
    //file("${path.module}/../../bots/examples/restaurant-bot.json")
    //file("${path.module}/../../bots/examples/simple-greeting-bot.json")
  )
}

# ============================================================================
# Lex Bot Module
# ============================================================================
# Instantiates the reusable Lex bot module with dev environment configuration.
# The module creates all necessary resources: bot, locales, intents, slots, etc.

module "lex_bot" {
  source      = "../../modules/lex-bot"
  bot_config  = local.bot_config
  environment = "dev"

  tags = {
    Project     = "LexPlatform"
    Environment = "dev"
    Owner       = "PlatformTeam"
  }
}
