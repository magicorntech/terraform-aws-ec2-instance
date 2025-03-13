# terraform-aws-ec2-instance

Magicorn made Terraform Module for AWS Provider
--
```
module "ec2-instance" {
  source      = "magicorntech/ec2-instance/aws"
  version     = "0.2.0"
  tenant      = var.tenant
  name        = var.name
  environment = var.environment
  vpc_id      = module.vpc.vpc_id
  cidr_block  = module.vpc.cidr_block
  subnet_id   = module.vpc.pbl_subnet_ids[0]
  encryption  = true
  kms_key_id  = module.kms.ec2_key_id[0]

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
  key_name                    = module.kms.ec2_key_pair_name[0] # can be null
  user_data                   = null # can be user-data or null

  ##### EBS Configuration
  delete_volumes_on_termination = true
  
  # Root Volume Configuration
  root_volume_type = "gp2" # can be null
  root_volume_size = 25    # can be null
  root_throughput  = null  # can be null
  root_iops        = null  # can be null

  # Additional Volume Configuration (you may set empty map {})
  data_disks = {
    xvdb = {
      ebs_volume_type = "gp3"
      ebs_volume_size = 50
      ebs_throughput  = 125
      ebs_iops        = 3000
    },
    xvdd = {
      ebs_volume_type = "gp3"
      ebs_volume_size = 100
      ebs_throughput  = 125
      ebs_iops        = 3000
    }
  }

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