data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "random_id" "iam" {
  byte_length = 6
}