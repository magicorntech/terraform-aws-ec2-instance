# terraform-aws-ec2-instance

Magicorn made Terraform Module for AWS Provider
--
```
module "ec2-instance" {
  source      = "magicorntech/ec2-instance/aws"
  version     = "0.0.4"
  tenant      = var.tenant
  name        = var.name
  environment = var.environment
  vpc_id      = module.vpc.vpc_id
  cidr_block  = module.vpc.cidr_block
  subnet_ids  = module.vpc.pbl_subnet_ids

  ##### EC2 Configuration
  ec2_name                    = "pritunl"
  ami_id                      = "ami-04e601abe3e1a910f"
  instance_type               = "t3a.small"
  associate_public_ip_address = true
  create_eip                  = true # you must have an internet gateway attached | otherwise, boom!
  detailed_monitoring         = false
  stop_protection             = true
  termination_protection      = true
  source_dest_check           = false
  instance_profile            = null # can be arn or null
  key_name                    = module.kms.ec2_key_pair_name[0] # can be null
  user_data                   = null # can be user-data or null

  ##### EBS Configuration
  encryption  = true
  kms_key_id  = module.kms.ec2_key_id[0]
  delete_volumes_on_termination = true
  
  # Root Volume Configuration
  root_volume_type = "gp3" # can be null
  root_volume_size = 10    # can be null
  root_throughput  = null  # can be null
  root_iops        = null  # can be null

  # Additional Volume Configuration (only one)
  ebs_device_name = "sda2"
  ebs_volume_type = "gp2" # can be null
  ebs_volume_size = 0     # if 0 - no additional disk created
  ebs_throughput  = null  # can be null
  ebs_iops        = null  # can be null

  # Security Group Configuration
  ingress = [
    {
      protocol    = "tcp"
      from_port   = 22
      to_port     = 22
      description = "Listen ssh from home"
      cidr_blocks = "95.12.34.56/32"
    },
    {
      protocol    = "tcp"
      from_port   = 80
      to_port     = 80
      cidr_blocks = "0.0.0.0/0"
    },
    {
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}
```

## Notes
1) Works better with magicorn-aws-kms module.
2) EC2 Key Pairs are set through magicorn-aws-kms module.