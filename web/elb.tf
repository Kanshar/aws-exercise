
resource "aws_elb" "web_elb" {
  name               = "apay-web-elb"
  availability_zones = [ var.availability-zone-1, var.availability-zone-2, var.availability-zone-3 ]

#  access_logs {
#    bucket        = aws_s3_bucket.web_elb_logs.id
#    interval      = 60
#  }

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = join("-", [ var.env_prefix, "web-elb" ])
    Environment = "Dev"
  }

}

resource "aws_autoscaling_attachment" "asg_attachment_web_elb" {
  autoscaling_group_name = aws_autoscaling_group.web_asg.id
  elb                    = aws_elb.web_elb.id
}

