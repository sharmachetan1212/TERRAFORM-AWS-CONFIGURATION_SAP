output "first_instance_public_ipv4" {
  value = aws_instance.app_server_db[0].public_ip
}
