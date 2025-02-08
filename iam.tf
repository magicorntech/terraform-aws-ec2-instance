resource "aws_iam_role" "main" {
  name = "${var.tenant}-${var.name}-ec2-${var.ec2_name}-role-${random_id.iam.hex}-${var.environment}"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name        = "${var.tenant}-${var.name}-ec2-${var.ec2_name}-role-${random_id.iam.hex}-${var.environment}"
    Tenant      = var.tenant
    Project     = var.name
    Environment = var.environment
    Maintainer  = "Magicorn"
    Terraform   = "yes"
  }
}

resource "aws_iam_role_policy_attachment" "main" {
  role       = aws_iam_role.main.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "main" {
  name = "${var.tenant}-${var.name}-ec2-${var.ec2_name}-ip-${random_id.iam.hex}-${var.environment}"
  role = aws_iam_role.main.name

  tags = {
    Name        = "${var.tenant}-${var.name}-ec2-${var.ec2_name}-ip-${random_id.iam.hex}-${var.environment}"
    Tenant      = var.tenant
    Project     = var.name
    Environment = var.environment
    Maintainer  = "Magicorn"
    Terraform   = "yes"
  }
}