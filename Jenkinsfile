node {

  environment {
             ECRURL = '049581233739.dkr.ecr.eu-central-1.amazonaws.com'
  }

  stage('Build') {
            steps {
              sh 'docker build -f ./node-3tier-app/api/Dockerfile -t $ECRURL+'/nodeapprepo':apiv1 ./node-3tier-app/api'
              sh 'docker build -f ./node-3tier-app/web/Dockerfile -t $ECRURL+'/nodeapprepo':apiv1 ./node-3tier-app/web'
              }
          }

  stage('Test') {
         steps{
         sh 'echo "Whaaaat? Testing"'
         }
  }

  stage 'Push'
  docker.withRegistry('https://'+$ECRURL, 'nodeapp_ecr_credentials') {
    docker.image($ECRURL+'/nodeapprepo').push('apiv1')
    docker.image($ECRURL+'/nodeapprepo').push('webv1')
  }
}
