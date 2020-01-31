output "ec2_ip" {
  value = aws_instance.web.public_ip
}

output "web_ami" { 
  value = aws_ami_from_instance.web_ami.id
}
