

resource "aws_launch_configuration" "web_lc" {
  name_prefix   = "apay-web-"
  image_id      = aws_ami_copy.web_ami_copy.id
  instance_type = "t2.micro"

  security_groups = [ aws_elb.web_elb.source_security_group_id, aws_security_group.allow_ssh2.id ]

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_autoscaling_group" "web_asg" {
  name               = "web-asg"
  availability_zones = [ var.availability-zone-1, var.availability-zone-2, var.availability-zone-3 ]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1

  launch_configuration = aws_launch_configuration.web_lc.id

  lifecycle {
    create_before_destroy = true
  }

  tags = [ 
    {
      key                 = "Name"
      value               = join("-", [ var.env_prefix, "web-asg" ])
      propagate_at_launch = true
    },
    {
      key                 = "Environment"
      value               = "Dev"
      propagate_at_launch = true
    }
  ]

}

