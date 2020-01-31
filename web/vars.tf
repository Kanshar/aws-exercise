
variable "server_ami" {
  default = "ami-04b3234e9ec9240a3"
}

variable home_ips {
  default = [ "194.193.169.172/32", "202.52.36.62/32", "203.222.145.57/32", "203.219.71.166/32" ]
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

variable "availability-zone-2" {
  default = "ap-southeast-2b"
}

variable "availability-zone-3" {
  default = "ap-southeast-2c"
}


