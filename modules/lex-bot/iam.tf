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

resource "aws_iam_role_policy_attachment" "lex_basic" {
  role       = aws_iam_role.lex_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonLexFullAccess"
}
