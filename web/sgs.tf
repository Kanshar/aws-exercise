resource "aws_security_group" "allow_web_tls2" {
  name        = "allow_web_tls2"
  description = "Allow, 80, 443 inbound traffic"

#  ingress {
#    from_port   = 8000
#    to_port     = 8000
#    protocol    = "tcp"
#    # Please restrict your ingress to only necessary IPs and ports.
#    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
#    cidr_blocks = [ "0.0.0.0/0" ] # add your IP address here
#  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = [ "0.0.0.0/0" ] # add your IP address here
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = [ "0.0.0.0/0" ] # add your IP address here
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = join("-", [ var.env_prefix, "sg-allow_web_tls2"] )
  }
}

resource "aws_security_group" "allow_ssh2" {
  name        = "allow_ssh2"
  description = "Allow ssh inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = var.home_ips
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = join("-", [ var.env_prefix, "sg-allow_ssh2"] )
  }
}

