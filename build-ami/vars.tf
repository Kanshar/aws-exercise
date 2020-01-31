variable "ssh_key_file" {
  default = "~/.ssh/ATOUCH.pem"
}

variable home_ips {
  default =  [ "194.193.169.172/32", "202.52.36.62/32", "203.222.145.57/32", "203.219.71.166/32" ]
}

variable "env_prefix" {
  default = "apay"
}

variable "key_name" {
  default = "ATOUCH"
}

variable "base_ami" {
  default = "ami-0328aad0f6218c429"
}

variable "region" {
  default = "ap-southeast-2"
}

variable "availability-zone-1" {
  default = "ap-southeast-2a"
}

