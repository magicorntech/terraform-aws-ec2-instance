##### Create EC2 IPs
resource "aws_eip" "main" {
  count      = (var.create_eip == true) ? 1 : 0
  instance   = aws_instance.main.id 
  domain     = "vpc"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = "${var.tenant}-${var.name}-${var.ec2_name}-eip-${var.environment}"
    Tenant      = var.tenant
    Project     = var.name
    Environment = var.environment
    Maintainer  = "Magicorn"
    Terraform   = "yes"
  }
}