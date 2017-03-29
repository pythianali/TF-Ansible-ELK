# Terraform-Ansible-ELK Stack

Note this stack is a continual work in progress and capabilities will change over time

## Table of Contents
* [Overview](https://github.com/pythianali/TF-Ansible-ELK#overview)
* [Requirements](https://github.com/pythianali/TF-Ansible-ELK#requirements)
* [Notes about build environment](https://github.com/pythianali/TF-Ansible-ELK#notes-about-build-environment)
* [Terraform.py submodule](https://github.com/pythianali/TF-Ansible-ELK#terraformpy-submodule)
* [Initialization Steps](https://github.com/pythianali/TF-Ansible-ELK#initialization-steps)
* [Launching the Stack](https://github.com/pythianali/TF-Ansible-ELK#launching-the-stack)
* [Destroying the Stack](https://github.com/pythianali/TF-Ansible-ELK#destroying-the-stack)

## Overview

This stack is designed to launch an ELK stack in an AWS environment using Terraform and Ansible for infrastructure creation and provisioning.  

The stack consists of the following components:

* Public VPC
* Internet Gateway
* NAT Gateway
* Security Groups
* Instances (one each for now)
  * Elasticsearch
  * Logstash
  * Kibana

## Requirements

* Access to an [AWS](https://aws.amazon.com/) account
* Ubuntu 16.04 AMI.  More options to follow later
* Ability to run t2small instances. There are issues with memory with the t2micro instances
* [AWSCLI](https://aws.amazon.com/cli/) installed locally and properly configured
* [Python](https://www.python.org/) installed locally
* [Ansible](http://docs.ansible.com/ansible/intro_installation.html) installed locally.  
* [Terraform](https://www.terraform.io/intro/getting-started/install.html) installed locally.

## Notes about build environment

The following versions of tools and OS were used to initially develop this stack
* Fedora 24
* Terraform 0.7.9
* Ansible 2.2.1.0
* Python 2.7.13
* awscli 1.11.21

## Terraform.py submodule

[Terraform.py](https://github.com/ciscocloud/terraform.py) is a neat submodule that we use to dynamically create an EC2 inventory for ansible to use in place of its inventory file.  It can be run at the CLI and will return IP and hostname values for the running environment.

## Initialization Steps

Grab the repository
```
git clone git@github.com:pythianali/TF-Ansible-ELK.git MyProjectFolder
```
Grab the submodules
```
cd MyProjectFolder
git submodule update --init --recursive --remote
```
Create a credentials file.  Update values accordingly for AWS keys
```

variable "AWS_ACCESS_KEY" {
  default = "MyAccessKEY"
}
variable "AWS_SECRET_KEY" {
  default = "MySecretKEY"
}

variable "KEY_NAME" {
  default = "TF-Ansible-ELK"
}

variable "LOCAL_KEY_NAME" {
  default = "keys/TF-Ansible-ELK.pem"
}

variable "INSTANCE_USERNAME" {
  default = "ubuntu"
}

```
Create a keys directory and add the EC2 keypair needed to access the instances.  The directory structure looks like below when completed

```
.
├── ansible
│   ├── ansible-elasticsearch
│   └── playbooks
├── creds.tf
├── instance.tf
├── keys
│   └── TF-Ansible-ELK.pem
├── provider.tf
├── README.md
├── sg.tf
├── terraform.py
│   ├── LICENSE
│   ├── README.md
│   ├── requirements.txt
│   ├── terraform.py
│   └── tests
├── vars.tf
└── vpc.tf

```

## Launching the Stack

To launch the stack you can run the following commands

```
terraform plan  
terraform apply
```
Plan provides an overview of changes to be applied and Apply will actually apply those changes

## Destroying the stack

To destroy the stack simply run:

```
terraform destroy
```
