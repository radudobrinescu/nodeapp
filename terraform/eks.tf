variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type        = "list"

  default = [
    {
      user_arn = "arn:aws:iam::049581233739:user/terraform_user"
      username = "terraform_user"
      group    = "system:masters"
    }
  ]
}

variable "map_users_count" {
  description = "The count of roles in the map_users list."
  type        = "string"
  default     = 1
}

variable "cluster_name" {}

module "eks" {
  source       = "terraform-aws-modules/eks/aws"
  cluster_name = "${var.cluster_name}"
  subnets      = ["${module.vpc.private_subnets}"]
  vpc_id       = "${module.vpc.vpc_id}"

  worker_groups = [
    {
      asg_desired_capacity = 2
      asg_max_size = 3
      asg_min_size = 0
      name = "worker_nodes_group1"
      #additional_userdata = "echo foo bar"
      subnets = "${join(",", module.vpc.private_subnets)}"
      additional_security_group_ids = "${aws_security_group.nodeapp_app_sg.id}"
      instance_type = "t2.small"
    }
  ]

  worker_group_count = 1
  map_users       = "${var.map_users}"
  map_users_count = "${var.map_users_count}"

  kubeconfig_name = "nodeapp_kubeconfig"
  config_output_path = "/home/opc/.kube/"
  kubeconfig_aws_authenticator_env_variables = { AWS_PROFILE = "terraform"}

}

resource "aws_ecr_repository" "nodeapprepo" {
  name = "nodeapprepo"

  provisioner "local-exec" {
   	command = "export ECR_URL=${aws_ecr_repository.nodeapprepo.repository_url} && chmod +x ../scripts/ecr_push.sh && ../scripts/ecr_push.sh $ECR_URL"
	}
}
