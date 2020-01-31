# so that terraform destroy can be run in the build-ami dir
resource "aws_ami_copy" "web_ami_copy" {
  name              = "web-ami-copy"
  source_ami_id     = var.server_ami
  source_ami_region = var.region

  tags = {
    Name = join("-", [ var.env_prefix, "web-ami-copy"])
  }
}
