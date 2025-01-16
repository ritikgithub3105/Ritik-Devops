output "bastion_public_ip" {
  value = aws_instance.public.public_ip
}

output "application_private_ip" {
  value = aws_instance.private1.private_ip
}

output "kafka_private_ip" {
  value = aws_instance.private2.private_ip
}

output "database_private_ip" {
  value = aws_instance.private3.private_ip
}
