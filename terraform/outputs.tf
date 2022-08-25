# AWS Account ID number of the account that owns or contains the calling entity
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

# Unique identifier of the calling entity
output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}

# Current region
output "current_aws_region" {
  value = data.aws_region.current.name
}

# Private EC2 IP
output "instance_private_ip" {
  value = aws_instance.web.private_ip
}

# EC2 subnet ID
output "instance_subnet_id" {
  value = aws_instance.web.subnet_id
}