variable "vpc_name" {}
variable "vpc_cidr_block" {}
variable "db_subnet1_cidr_block" {}
variable "db_subnet2_cidr_block" {}
variable "app_subnet1_cidr_block" {}
variable "app_subnet2_cidr_block" {}
variable "app_subnet3_cidr_block" {}
variable "web_subnet1_cidr_block" {}
variable "web_subnet2_cidr_block" {}
variable "web_subnet3_cidr_block" {}

#locals {
#	public_subnet_tag name1 = "kubernetes.io/cluster/${var.cluster_name}"
#	public_subnet_tag name2 = "kubernetes.io/role/elb"
#}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "1.59.0"

  name = "${var.vpc_name}"
  cidr = "${var.vpc_cidr_block}"

  azs              = ["${var.region}a", "${var.region}b", "${var.region}c"]
  database_subnets = ["${var.db_subnet1_cidr_block}", "${var.db_subnet2_cidr_block}"]
  private_subnets  = ["${var.app_subnet1_cidr_block}", "${var.app_subnet2_cidr_block}", "${var.app_subnet3_cidr_block}"]
  public_subnets   = ["${var.web_subnet1_cidr_block}", "${var.web_subnet2_cidr_block}", "${var.web_subnet3_cidr_block}"]

  create_database_subnet_group = false
  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_nat_gateway = true
  private_subnet_tags = {

	}

  public_subnet_tags = {
	"kubernetes.io/cluster/nodeapp-cluster" = "shared"
	"kubernetes.io/role/elb" = "1"
#	"${var.public_subnet_tag_name1}" = "shared"
#	"${var.public_subnet_tag_name2}" = "1"
	}
}

resource "aws_security_group" "nodeapp_web_sg" {
  name        = "nodeapp_web_sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "nodeapp_app_sg" {
  name        = "nodeapp_app_sg"
  description = "Allow inbound traffic from web tier"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    security_groups = ["${aws_security_group.nodeapp_web_sg.id}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "nodeapp_db_sg" {
  name        = "nodeapp_db_sg"
  description = "Allow inbound traffic from app tier"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    security_groups = ["${aws_security_group.nodeapp_app_sg.id}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["${aws_security_group.nodeapp_app_sg.id}"]
  }
}
