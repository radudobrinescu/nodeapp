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
                  docker.withRegistry("https://${params.ECRURL}", 'ecr:eu-central-1:ecr_cred') {
                    docker.image("$API_IMAGE").push()
                    docker.image("$WEB_IMAGE").push()
                  }
                } 
            }
        }
        stage('Deploy to EKS') {
            steps {
                sh 'sed -i "s/{{API_TAG}}/$API_TAG/g" ./kubernetes/api.yaml'
                sh 'sed -i "s/{{WEB_TAG}}/$WEB_TAG/g" ./kubernetes/web.yaml'
                sh "kubectl apply -f ./kubernetes/ --kubeconfig=/home/tomcat/kubeconfig"
                
            }
        }

    }
}
