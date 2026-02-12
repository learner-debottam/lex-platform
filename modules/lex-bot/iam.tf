# ============================================================================
# IAM Role for Lex Bot
# ============================================================================
# Creates an IAM role that allows AWS Lex service to perform actions on behalf
# of the bot. This role is required for the bot to function.

resource "aws_iam_role" "lex_role" {
  name = "${local.bot_name}-lex-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "lexv2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# ============================================================================
# IAM Policy Attachment
# ============================================================================
# Attaches the AWS managed policy for Lex full access to the bot's IAM role.
# This provides necessary permissions for bot operations.

resource "aws_iam_role_policy_attachment" "lex_basic" {
  role       = aws_iam_role.lex_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonLexFullAccess"
}
