resource "aws_lexv2models_bot_version" "this" {
  bot_id = aws_lexv2models_bot.this.id

  locale_specification = {
    for locale_id, _ in local.locales : locale_id => {
      source_bot_version = "DRAFT"
    }
  }

  depends_on = [
    aws_lexv2models_intent.intents,
    aws_lexv2models_slot.slots,
    terraform_data.sample_utterances
  ]
}
