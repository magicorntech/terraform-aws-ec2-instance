resource "aws_ebs_volume" "data" {
  for_each          = var.data_disks
  encrypted         = (var.encryption == true) ? true : false
  kms_key_id        = (var.encryption == true) ? var.kms_key_id : null
  type              = each.value.ebs_volume_type
  size              = each.value.ebs_volume_size
  throughput        = each.value.ebs_throughput
  iops              = each.value.ebs_iops
  availability_zone = aws_instance.main.availability_zone

  tags = {
    Name        = "${var.tenant}-${var.name}-ec2-${var.ec2_name}-${each.key}-volume-${var.environment}"
    Tenant      = var.tenant
    Project     = var.name
    Environment = var.environment
    Maintainer  = "Magicorn"
    Terraform   = "yes"
  }
}

resource "aws_volume_attachment" "data" {
  for_each    = var.data_disks
  device_name = "/dev/${each.key}"
  volume_id   = aws_ebs_volume.data[each.key].id
  instance_id = aws_instance.main.id
}
