node {

  environment {
             ECRURL = '049581233739.dkr.ecr.eu-central-1.amazonaws.com'
  }

  stage 'Docker build'
  docker.build($ECRURL'/nodeapprepo:apiv1')
  docker.build($ECRURL/nodeapprepo:webv1')

  stage 'Docker push'
  docker.withRegistry('https://049581233739.dkr.ecr.eu-central-1.amazonaws.com', 'nodeapp_ecr_credentials') {
    docker.image('049581233739.dkr.ecr.eu-central-1.amazonaws.com/nodeapprepo').push('apiv1')
    docker.image('049581233739.dkr.ecr.eu-central-1.amazonaws.com/nodeapprepo').push('webv1')
  }
}
