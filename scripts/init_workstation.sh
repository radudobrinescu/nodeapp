#! /bin/bash

if [ "$1" != "test" ]
then 

read -p "Enter AWS ACCESS KEY ID: " key_id
read -p "Enter AWS SECRET ACCESS KEY: " secret_access_key
read -p "Continue? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

CRED="[terraform]\naws_access_key_id = $key_id\naws_secret_access_key = $secret_access_key\n"
CRED_FILE=~/.aws/credentials
CONFIG="[profile terraform]\nregion = eu-central-1"
if [ ! -f "$CRED_FILE" ]; then
        mkdir -p ~/.aws 2>/dev/null
fi
echo -e $CRED >> $CRED_FILE
echo -e $CONFIG >> ~/.aws/config
echo "Credentials have been saved for profile <terraform> "
echo "Region for this profile is set to <eu-central-1> "

echo ""
echo "Installling AWS CLI..."
curl -O https://bootstrap.pypa.io/get-pip.py
python get-pip.py --user
source .bash_profile
pip install awscli --upgrade --user

echo ""
echo "Installing TERRAFORM..."
wget https://releases.hashicorp.com/terraform/0.11.11/terraform_0.11.11_linux_amd64.zip
unzip terraform_0.11.11_linux_amd64.zip
sudo mv terraform /usr/local/bin

echo ""
echo "Installing DOCKER..."
sudo yum install -y docker-engine
sudo systemctl start docker
sudo usermod -aG docker $USER

echo ""
echo "Installing KUBECTL"
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.11.5/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

echo ""
echo "Installing aws-cli-authenticator for EKS..."
curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.11.5/2018-12-06/bin/linux/amd64/aws-iam-authenticator
chmod +x ./aws-iam-authenticator
cp ./aws-iam-authenticator $HOME/aws-iam-authenticator && export PATH=$HOME:$PATH
echo 'export PATH=$HOME:$PATH' >> ~/.bashrc

source ~/.bash_profile
source ~/.bashrc

fi

export AWS_PROFILE=terraform
echo "Testing the tools..."
echo ""

if aws sts get-caller-identity | grep -q 'user'; then
   echo "aws cli.................OK"
else
   echo "oops, something went wrong with aws cli"
fi

if terraform | grep -q 'Common commands'; then
   echo "terraform...............OK"
else
   echo "oops, something went wrong with terraform"
fi

if kubectl | grep -q 'apply'; then
   echo "kubectl.................OK"
else
   echo "oops, something went wrong with kubectl"
fi

if docker images | grep -q 'REPOSITORY'; then
   echo "docker..................OK"
else
   echo "oops, something went wrong with docker. Try to login in a new shell. "
fi

if aws-iam-authenticator | grep -q 'Help about any command'; then
   echo "aws-iam-authenticator...OK"
else
   echo "oops, something went wrong with the aws-iam-authenticator"
fi
 



# aws sts get-caller-identity

