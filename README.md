# aws-exercise
Exercise on AWS Infrastructure and configuration - using Terraform and Ansible

## FINAL SOLUTION

There are two main steps:
- Create an AMI with the appropriate configuration
- Using the AMI, deploy a web server with an ASG running behind an ELB

This will ensure that if the web server instance goes down, the ASG 
will spin up a new fully-configured instance and the web page will 
continue to be served from the same address.

_FUTURE ENHANCEMENT_ - 
 - *Could use a `build-ami` module which returns the 
AMI ID. With this structure, only one `terraform apply` command will be 
enough for configuration and deployment together.*
 -  *Probably use a VPC with a bastion host to secure ssh access to the 
web server.*

### Security considerations
1. HTTP access is enabled on port 80 to the ELB, from any IP. 
2. HTTP access to the web server is possible only through the ELB.
3. SSH access is enabled to the EC2 instance on port 22, but this 
   is restricted to specific host IPs (defined in `vars.tf:home_ips` 
   variable). 
4. Have used EC2-classic instances plus Classic ELB by using default 
   VPC. Security could further be enhanced by placing the resources 
   in a dedicated VPC rather than in a shared environment.
5. Ignoring strict host key checking to play ansible scripts.

### Assumptions
1. Using Ubuntu-16 AMI available from AWS Marketplace should be good for base AMI. 
2. Ubuntu-16 uses timedatectl to configure ntp. As this comes pre-installed, ntp is not installed. Only timezone (set to Melbourne/Australia) configuration is done.
3. mtr and telnet are pre-installed in the base AMI - hence not handled in ansible scripts. 
4. There is no monitoring setup for the deployment (e.g. ELB access logs are not captured). 
5. Only one EC2 instance will be spawned as part of the ASG.
6. Though an ASG is used here, the deployment has not been tested for scale.

## Steps to Deploy

### Pre-requisites

#### Install on local machine (host)
1. Terraform 0.12 - https://www.terraform.io/downloads.html
2. Ansible - https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html

#### Create AWS key pair 
1. Goto Services->EC2->Key Pair. 
2. Click "Create Key Pair". 
3. Fill appropriate name for the keypair (say ATOUCH) and choose File Format ".pem". 
4. On clicking Create, the `ATOUCH.pem.txt` file should be downloaded to your local machine.

#### Configure ssh access
1. Copy and rename the "ATOUCH.pem.txt" file to `$HOME/.ssh/ATOUCH.pem` and 
   add the key to the ssh agent.
```
cp ATOUCH.pem.txt ~/.ssh/ATOUCH.pem
ssh-add ATOUCH.pem
```

### Build AMI 
Use tf to spin up EC2 instance and create AMI from it.
The script uses a base Ubuntu-16 AMI to setup a EC2 instance and then runs 
ansible scripts to configure it. A new AMI is created from the fully-configured
instance.
```
git clone https://github.com/Kanshar/aws-exercise.git
cd aws-exercise/build-ami

# NOTE: 
#   If you are using a different name (other than `~/.ssh/ATOUCH.pem`) for 
#   the ssh key file, please update it in `vars.tf:ssh_key_file` variable.

terraform init
terraform plan -refresh -out=plan.a
terraform apply plan.a
```
**NOTE**: Please copy the `web_ami` value from the output of the last command.

### Deploy
The new AMI, built above, is copied to another AMI and deployed in an ASG 
with an ELB in front. Copying the AMI allows the _build-ami_ infrastructure 
to be taken down later without affecting the web server deployment. 
```
cd ../web

# NOTE:
#   1. Update `vars.tf:server_ami` variable with the `web_ami` value obtained above.
#   2. If you need to ssh into the instance, update `vars.tf:home_ips` variable with 
#      your host IP addresses.

terraform init
terraform plan -refresh -out=plan.a
terraform apply plan.a
```
NOTE: Please copy the `elb_dns_name` value from the output of the last command.
Open a browser and paste this value to the address bar.
This should display **Hello Afterpay!** (might have to refresh the page a few times).

#### Cleanup resources used to build AMI
Use tf to clean up the resources used for building the AMI
```
cd ../build-ami
terraform plan -destroy -out=plan.x
terraform apply plan.x
```

