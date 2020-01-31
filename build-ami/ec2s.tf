
resource "aws_instance" "web" {
  ami           = var.base_ami
  instance_type = "t2.micro"
  key_name      = var.key_name

  availability_zone           = var.availability-zone-1
  associate_public_ip_address = true

  security_groups = [ aws_security_group.allow_ssh1.name, 
                      aws_security_group.allow_web_tls1.name ]

  tags = {
    Name = join("-", [ var.env_prefix, "HelloWorld" ])
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = true
    encrypted             = false
  }

  # wait for instance to be up 
  provisioner "file" {
    source      = "sgs.tf"
    destination = "/tmp/sgs.tf"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = aws_instance.web.public_ip
      private_key = file("${var.ssh_key_file}")
    }
  }
}

resource "null_resource" "RunAnsiblePlaybook" {
  provisioner "local-exec" {
    command = "echo ${aws_instance.web.public_ip} > hosts"
  }
  # wait for ssh agent
  provisioner "local-exec" {
    command = "sleep 150"
  }
  provisioner "local-exec" {
    command = "ansible-playbook --key-file ${var.ssh_key_file} -i ./hosts -u ubuntu ./ansible-scripts/install.yml"
  }
}

resource "aws_ami_from_instance" "web_ami" {
  name               = "web-ami2"
  source_instance_id = aws_instance.web.id

  tags = {
    Name = join("-", [ var.env_prefix, "web-ami2"])
  }

  timeouts {
    create = "10m"
    update = "10m"
  }

  depends_on = [ null_resource.RunAnsiblePlaybook ]
}
