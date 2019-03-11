# NodeJS 3tier App

<placeholder for architecture diagram> test

## Project prerequisites

##### AWS Account:
A non-administrative user with the following permissions is required:

* AmazonEC2ContainerRegistryFullAccess
* AmazonRDSFullAccess
* AmazonEC2FullAccess
* Directly attached policy from here:
https://github.com/terraform-aws-modules/terraform-aws-eks/tree/master/examples/eks_test_fixture (required for EKS)

##### Workstation/control machine
A VM or local laptop with the necessary tools to run the project.
To install the required tools on a Linux machine follow the steps below:

1. Clone this repository on the control machine
2. Execute */scripts/init_workstation.sh*
3. If you already have some of the tools installed, you can validate with */scripts/init_workstation.sh test*

## Provision the infrastructure
To provision the project's infrastructure in AWS, first set up the necessary terraform providers and then plan and apply the configurations:
```
1. cd terraform
   terraform init
2. terraform plan -var-file=variables.tfvars
3. terraform apply -var-file=variables.tfvars
```
To clean up the environment:
```
4. terraform destroy -var-file=variables.tfvars
```

## Test the application

To make sure that the infrastructure has been provisioned and that the application properly deployed, simply get the Load Balancer endpoint from the *terraform apply* command output and enter the value in a browser. You should be able to see the application.

## Updating the application
