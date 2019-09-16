pipeline{
  agent any

    environment {
             API_TAG =  "api-${BUILD_NUMBER}"
             WEB_TAG =  "web-${BUILD_NUMBER}"
             API_IMAGE = "${params.ECRURL}/nodeapprepo:$API_TAG"
             WEB_IMAGE = "${params.ECRURL}/nodeapprepo:$WEB_TAG"
    }

  stages {

      stage('Test') {
        steps{
          sh 'npm install ./node-3tier-app/api'
          sh 'npm install ./node-3tier-app/web'

        }

      }

      stage('Build Docker Image') {
          steps {
              sh 'docker build -f ./node-3tier-app/api/Dockerfile -t $API_IMAGE ./node-3tier-app/api'
              sh 'docker build -f ./node-3tier-app/web/Dockerfile -t $WEB_IMAGE ./node-3tier-app/web'
          }
       }

      stage('Push to ECR') {
          steps {
                script {
                  docker.withRegistry("https://${params.ECRURL}", 'ecr:us-east-1:ecr_cred') {
                    docker.image("$API_IMAGE").push()
                    docker.image("$WEB_IMAGE").push()
                  }
                sh "docker rmi $API_IMAGE $WEB_IMAGE"
                } 
            }
        }
        stage('Deploy to EKS') {
            steps {
                script {
                  withKubeConfig([credentialsId: 'default-service-account', serverUrl: "${params.EKSURL}"]) {
                    sh "kubectl --record deployment.apps/nodeapp-api set image deployment.v1.apps/nodeapp-api nodeapp-api=$API_IMAGE"
                    sh "kubectl --record deployment.apps/nodeapp-web set image deployment.v1.apps/nodeapp-web nodeapp-web=$WEB_IMAGE"
                  }
                }
            }
        }

    }
}
