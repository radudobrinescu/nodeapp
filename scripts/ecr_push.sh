export ecr_repository_url=$1
echo "URL to use is: "+ $ecr_repository_url
docker build -t $ecr_repository_url:apiv1 ../node-3tier-app/api/
docker build -t $ecr_repository_url:webv1 ../node-3tier-app/web/
export AWS_PROFILE=terraform
aws ecr get-login --no-include-email >>  ../scripts/docker_login.sh && chmod +x ../scripts/docker_login.sh
source ../scripts/docker_login.sh
rm ../scripts/docker_login.sh
docker push $ecr_repository_url:apiv1
docker push $ecr_repository_url:webv1
