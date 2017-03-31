resource "aws_security_group" "TF-Ansible-ELK-SG" {
  vpc_id = "${aws_vpc.VPC-TF-Ansible-ELK.id}"
  name = "TF-Ansible-ELK-SG"
  description = "security group that allows ssh and all egress traffic"
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  } 

  tags {
    Name = "TF-Ansible-ELK-SG"
    AccountID = "${data.aws_caller_identity.current.account_id}"
  }
}
