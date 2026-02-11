resource "terraform_data" "sample_utterances" {
  for_each = {
    for intent in local.intents :
    "${intent.locale}-${intent.name}" => intent
    if length(intent.sample_utterances) > 0
  }

  triggers_replace = {
    utterances = jsonencode(each.value.sample_utterances)
    intent_id  = aws_lexv2models_intent.intents[each.key].intent_id
  }

  provisioner "local-exec" {
    command = <<-EOT
      echo '${base64encode(jsonencode([for u in each.value.sample_utterances : { utterance = u }]))}' | base64 -d > /tmp/utterances-${each.key}.json
      aws lexv2-models update-intent \
        --bot-id ${aws_lexv2models_bot.this.id} \
        --bot-version DRAFT \
        --locale-id ${each.value.locale} \
        --intent-id ${aws_lexv2models_intent.intents[each.key].intent_id} \
        --intent-name ${each.value.lex_id} \
        --sample-utterances file:///tmp/utterances-${each.key}.json \
        --region ${data.aws_region.current.id}
      rm /tmp/utterances-${each.key}.json
    EOT
  }

  depends_on = [
    aws_lexv2models_slot.slots
  ]
}

data "aws_region" "current" {}
