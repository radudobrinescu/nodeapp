pipeline {
    agent any

    environment {
             ECRURL = '049581233739.dkr.ecr.eu-central-1.amazonaws.com'
             API_IMAGE = "${ECRURL}/nodeapprepo:apiv2"
             WEB_IMAGE = "${ECRURL}/nodeapprepo:webv2"
    }

    stages {
       stage('Build') {
            steps {
              sh 'docker build -f ./node-3tier-app/api/Dockerfile -t $API_IMAGE ./node-3tier-app/api'
              sh 'docker build -f ./node-3tier-app/web/Dockerfile -t $WEB_IMAGE ./node-3tier-app/web'
            }
       }

        stage('Test') {
            steps {
                echo 'Testing..'
            }
        }
        stage('Push') {
            steps {
                sh 'aws ecr get-login --no-include-email >> docker_login.sh && chmod +x docker_login.sh && source docker_login.sh && rm docker_login.sh'
                sh 'docker push $API_IMAGE'
                sh 'docker push $WEB_IMAGE'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}
