output "public_ip" {
  value = aws_instance.dev-instance.public_ip
}
output "private_ip" {
  value = aws_instance.dev-instance.private_ip
}
output "public_dns" {
  value = aws_instance.dev-instance.public_dns
}
# -------------------------
# Output
# -------------------------
output "dev_instance_public_ip" {
  value = aws_eip.dev-eip.public_ip
}
