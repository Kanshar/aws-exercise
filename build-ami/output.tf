output "ec2-ip" {
  value = aws_instance.web.public_ip
}

output "web-ami" { 
  value = aws_ami_from_instance.web_ami.id
}
