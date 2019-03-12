pipeline{
  agent any

    environment {

             API_IMAGE = "${params.ECRURL}/nodeapprepo:api-${BUILD_NUMBER}"
             WEB_IMAGE = "${params.ECRURL}/nodeapprepo:web-${BUILD_NUMBER}"
    }
/*
     stage('Cloning Git') {
            git 'https://github.com/radudobrinescu/nodeapp'
            credentialsId: 'radud-github-credentials'
        }

      stage('Install dependencies') {
        try {
            sh 'npm install'
            }
        catch(e){
            notify("Something failed while installing dependecies")
            throw e;
        }
      }

      stage('Run tests') {
        try{
          sh 'npm run test'
              if (currentBuild.result.equals("FAILURE")) {
              throw "Test results did not pass thresholds."
              }
          }
        catch(e){
            notify("Some tests failed")
            throw e;
        }
      }
      */
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
                sh "export KUBECONFIG='${params.KUBECONFIG}'"
                sh 'cat ./kubernetes/api.yaml | sed -e "s/{{API_IMAGE}}/$API_IMAGE/g" |kubectl apply -f -'
                sh 'cat ./kubernetes/web.yaml | sed -e "s/{{WEB_IMAGE}}/$WEB_IMAGE/g" |kubectl apply -f -'
                
            }
        }

    }
}
