# Executing this script will install all necessary tools for setting up the project

### A AWS user with appropriate roles is required so adding the credentials

cat << EOF | ~/.aws/credentials -
[terraform]
aws_access_key_id = <>
aws_secret_access_key = <>
EOF

~/.aws/credentials with this content:
[terraform]
aws_access_key_id = <>
aws_secret_access_key = <>

~/.aws/config
[profile terraform]
region = eu-central-1

### Installing pip -- required for AWS CLI
curl -O https://bootstrap.pypa.io/get-pip.py
python get-pip.py --user
source .bash_profile
pip install awscli --upgrade --user

### Installing terraform
wget https://releases.hashicorp.com/terraform/0.11.11/terraform_0.11.11_linux_amd64.zip
unzip terraform_0.11.11_linux_amd64.zip
sudo mv terraform /usr/local/bin

### Installing docker
sudo yum install docker-engine
sudo systemctl start docker
sudo usermod -aG docker $USER
(may need to relogin to run docker as non-root user)

### Installing kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.11.5/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

### Installing aws-iam-authenticator for EKS
curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.11.5/2018-12-06/bin/linux/amd64/aws-iam-authenticator
chmod +x ./aws-iam-authenticator
cp ./aws-iam-authenticator $HOME/aws-iam-authenticator && export PATH=$HOME:$PATH
echo 'export PATH=$HOME:$PATH' >> ~/.bashrc
aws-iam-authenticator help

### Testing that all the tools have been properly set up:
echo "Testing all tools..."
