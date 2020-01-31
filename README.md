# aws-exercise
Exercise on AWS Infrastructure and configuration - using Terraform and Ansible

## PLAN 1 - Details to be ironed out

1. Terraform spin up AWS EC2 instance - ubuntu 16 using AMI from marketplace - Done
2. Configure ssh access in security group. - Done
3. Ansible configure using terraform null_resource and remote-exec provisioner - TBD
4. Terraform aws_ami_from_instance to create AMI from EC2 instance - Done
5. Create required security groups for the ELB and EC2 instances - Done
6. Spin up aws_asg and launch-configuration using the created AMI - Done
7. Spin up aws_elb resource to provide load balancing - Done
8. Terminate initial EC2 instance - Done (manual)

## PLAN 2 - Split the procedure into four steps

1. Use tf to spin up instance with base Ubuntu image 
2. Run ansible scripts to configure it  
3. Run script to create AMI from configured instance
4. Use tf to spin up AWS ELB, and ASG with the newly built AMI 


## Ansible configuration

1. apt update
2. disable ipv6 and set max files
3. check NTP configuration using timedatectl
4. install tree, python, python-pip, apache2, libapache2-mod-wsgi plus flask, virtualenv
5. setup virtualenv
6. copy .py, .wsgi and .conf files into appropriate directories
7. disable default site
8. enable new site
9. restart apache2

## Assumptions

1. Ubuntu16 uses timedatectl to configure ntp. This comes pre-installed. Hence ntp is not installed.
2. mtr and telnet are pre-installed - checked.
3. There is no monitoring setup for the deployment (e.g. ELB access logs are not captured). 
4. HTTP access is enabled on port 80 to the ELB, from any IP. 
5. HTTP access to the web server is enabled only through the ELB.
6. SSH access is enabled to the instance on port 22, but this is restricted to specific host IPs (defined in `vars.tf` variable `home_ips`). 


## Steps to Deploy

### Pre-requisites

#### Install on local machine (host)
1. Terraform 0.12 - https://www.terraform.io/downloads.html
2. Ansible - https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html

#### Create AWS key pair 
1. Goto Services->EC2->Key Pair. 
2. Click "Create Key Pair". 
3. Fill appropriate name for the keypair (say ATOUCH) and choose File Format ".pem". 
4. On clicking Create, the "ATOUCH.pem.txt" file should be available in your local machine.

#### Configure ssh access
1. Copy the "ATOUCH.pem.txt" file to `$HOME/.ssh/` and add the key to the ssh agent.
```
cp ATOUCH.pem.txt ~/.ssh
ssh-add ATOUCH.pem.txt
```

### Build AMI for deployment
1. Use tf to spin up instance with base Ubuntu image 
2. Run ansible scripts to configure it  
3. Run script to create AMI from configured instance

### Deploy
1. Use tf to spin up AWS ELB, and ASG with the newly built AMI
