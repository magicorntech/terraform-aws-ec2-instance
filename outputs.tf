output "primary_nic" {
	value = aws_instance.main.primary_network_interface_id
}