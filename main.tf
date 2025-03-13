resource "aws_instance" "main" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  associate_public_ip_address = var.associate_public_ip_address
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.main.id]
  monitoring                  = var.detailed_monitoring
  disable_api_stop            = var.stop_protection
  disable_api_termination     = var.termination_protection
  source_dest_check           = var.source_dest_check
  iam_instance_profile        = aws_iam_instance_profile.main.id
  key_name                    = var.key_name
  user_data                   = var.user_data
  tenancy                     = "default"

  credit_specification {
    cpu_credits = "unlimited"
  }

  maintenance_options {
    auto_recovery = "default"
  }

  root_block_device {
    delete_on_termination = var.delete_volumes_on_termination
    encrypted             = (var.encryption == true) ? true : false
    kms_key_id            = (var.encryption == true) ? var.kms_key_id : null
    volume_type           = var.root_volume_type
    volume_size           = var.root_volume_size
    throughput            = var.root_throughput
    iops                  = var.root_iops

    tags = {
      Name        = "${var.tenant}-${var.name}-ec2-${var.ec2_name}-root-volume-${var.environment}"
      Tenant      = var.tenant
      Project     = var.name
      Environment = var.environment
      Maintainer  = "Magicorn"
      Terraform   = "yes"
    }
  }

  tags = {
    Name        = "${var.tenant}-${var.name}-ec2-${var.ec2_name}-${var.environment}"
    Tenant      = var.tenant
    Project     = var.name
    Environment = var.environment
    Maintainer  = "Magicorn"
    Terraform   = "yes"
  }
}
