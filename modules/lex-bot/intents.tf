resource "aws_lexv2models_intent" "intents" {
  for_each = {
    for intent in local.intents :
    "${intent.locale}-${intent.name}" => intent
  }

  bot_id      = aws_lexv2models_bot.this.id
  bot_version = "DRAFT"
  locale_id   = each.value.locale
  name        = each.value.lex_id
  description = each.value.description

  lifecycle {
    create_before_destroy = false
    ignore_changes = [sample_utterance]
  }

  depends_on = [
    aws_lexv2models_bot_locale.locales
  ]
}



resource "aws_lexv2models_slot_type" "slot_types" {
  for_each = {
    for st in local.slot_types :
    "${st.locale}-${st.name}" => st
  }

  bot_id      = aws_lexv2models_bot.this.id
  bot_version = "DRAFT"
  locale_id   = each.value.locale
  name        = each.value.lex_id
  description = each.value.description

  dynamic "slot_type_values" {
    for_each = each.value.values
    content {
      sample_value {
        value = slot_type_values.value
      }
    }
  }

  value_selection_setting {
    resolution_strategy = "OriginalValue"
  }

  depends_on = [
    aws_lexv2models_bot_locale.locales
  ]
}


resource "aws_lexv2models_slot" "slots" {
  for_each = {
    for slot in local.slots :
    "${slot.locale}-${slot.intent}-${slot.name}" => slot
  }

  bot_id      = aws_lexv2models_bot.this.id
  bot_version = "DRAFT"
  locale_id   = each.value.locale
  intent_id   = aws_lexv2models_intent.intents["${each.value.locale}-${each.value.intent}"].intent_id
  name        = each.value.name
  description = each.value.description
  slot_type_id = startswith(each.value.slot_type, "AMAZON.") ? each.value.slot_type : aws_lexv2models_slot_type.slot_types["${each.value.locale}-${each.value.slot_type}"].slot_type_id

  value_elicitation_setting {
    slot_constraint = each.value.required ? "Required" : "Optional"
    prompt_specification {
      max_retries = 2
      allow_interrupt = true
      message_selection_strategy = "Random"
      message_group {
        message {
          plain_text_message { value = each.value.prompt }
        }
      }
      prompt_attempts_specification {
        map_block_key = "Initial"
        allow_interrupt = true
        allowed_input_types {
          allow_audio_input = true
          allow_dtmf_input = true
        }
        audio_and_dtmf_input_specification {
          start_timeout_ms = 4000
          audio_specification {
            max_length_ms = 15000
            end_timeout_ms = 640
          }
          dtmf_specification {
            max_length = 513
            end_timeout_ms = 5000
            deletion_character = "*"
            end_character = "#"
          }
        }
        text_input_specification {
          start_timeout_ms = 30000
        }
      }
      prompt_attempts_specification {
        map_block_key = "Retry1"
        allow_interrupt = true
        allowed_input_types {
          allow_audio_input = true
          allow_dtmf_input = true
        }
        audio_and_dtmf_input_specification {
          start_timeout_ms = 4000
          audio_specification {
            max_length_ms = 15000
            end_timeout_ms = 640
          }
          dtmf_specification {
            max_length = 513
            end_timeout_ms = 5000
            deletion_character = "*"
            end_character = "#"
          }
        }
        text_input_specification {
          start_timeout_ms = 30000
        }
      }
      prompt_attempts_specification {
        map_block_key = "Retry2"
        allow_interrupt = true
        allowed_input_types {
          allow_audio_input = true
          allow_dtmf_input = true
        }
        audio_and_dtmf_input_specification {
          start_timeout_ms = 4000
          audio_specification {
            max_length_ms = 15000
            end_timeout_ms = 640
          }
          dtmf_specification {
            max_length = 513
            end_timeout_ms = 5000
            deletion_character = "*"
            end_character = "#"
          }
        }
        text_input_specification {
          start_timeout_ms = 30000
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [
      value_elicitation_setting[0].prompt_specification[0].prompt_attempts_specification,
      value_elicitation_setting[0].prompt_specification[0].allow_interrupt,
      value_elicitation_setting[0].prompt_specification[0].message_selection_strategy
    ]
  }

  depends_on = [
    aws_lexv2models_intent.intents,
    aws_lexv2models_slot_type.slot_types
  ]
}

