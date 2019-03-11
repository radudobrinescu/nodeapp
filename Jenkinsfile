pipeline {
    agent any

    environment {
             ECRURL = '049581233739.dkr.ecr.eu-central-1.amazonaws.com'
    }

    stages {
       stage('Build') {
              sh 'docker build -f ./node-3tier-app/api/Dockerfile -t $ECRURL+'/nodeapprepo':apiv1 ./node-3tier-app/api'
              sh 'docker build -f ./node-3tier-app/web/Dockerfile -t $ECRURL+'/nodeapprepo':apiv1 ./node-3tier-app/web'
              }
          }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
            }
        }
        stage('Push') {
            steps {
                sh 'echo ${params.ecr_url}'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}
