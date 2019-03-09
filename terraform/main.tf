variable "region" {}
variable "shared_credentials_file" {}
variable "profile" {}

provider "aws" {
  region                  = "${var.region}"
  shared_credentials_file = "${var.shared_credentials_file}"
  profile                 = "${var.profile}"
}
