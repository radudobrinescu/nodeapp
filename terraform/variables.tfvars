region = "eu-central-1"
shared_credentials_file = "/home/opc/.aws/credentials"
profile = "terraform"
my_ami = {
    "eu-west-1" = "ami-f90a4880"
    "eu-west-3" = "ami-0e55e373"
    "eu-central-1" = "ami-0bdf93799014acdc4"
  }


#Networking

vpc_name= "nodeapp_vpc"
vpc_cidr_block = "10.0.0.0/16"

db_subnet1_cidr_block = "10.0.11.0/24"
db_subnet2_cidr_block = "10.0.12.0/24"

app_subnet1_cidr_block = "10.0.21.0/24"
app_subnet2_cidr_block = "10.0.22.0/24"
app_subnet3_cidr_block = "10.0.23.0/24"

web_subnet1_cidr_block = "10.0.31.0/24"
web_subnet2_cidr_block = "10.0.32.0/24"
web_subnet3_cidr_block = "10.0.33.0/24"

#EKS

cluster_name = "nodeapp-cluster"
