terraform {
  backend "s3" {
    bucket         = "lex-platform-tfstate"
    key            = "lex/prod/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "lex-platform-tfstate-lock"
    encrypt        = true
  }
}
