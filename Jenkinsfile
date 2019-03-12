pipeline{
  agent any

    environment {
/*             ECRURL = '049581233739.dkr.ecr.eu-central-1.amazonaws.com'
             RDSURL = 'nodeappdb.csgfumxmknbk.eu-central-1.rds.amazonaws.com:5432'
             EKSURL = 'https://9F9CCB46ADCB3C751F4E3B2835285063.yl4.eu-central-1.eks.amazonaws.com'
*/
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
                /*sh 'rm  ~/.dockercfg || true'
                sh 'rm ~/.docker/config.json || true'
                sh 'eval $(export AWS_PROFILE="terraform" && ~/.local/bin/aws ecr get-login --no-include-email)'
                sh 'docker push $API_IMAGE'
                sh 'docker push $WEB_IMAGE'*/
                script {
                  docker.withRegistry("https://${params.ECRURL}", "nodeapp_ecr_credentials-EU_CENTRAL_1") {
                    docker.image("$API_IMAGE").push()
                    docker.image("${params.ECRURL}/nodeapprepo").push("web-${BUILD_NUMBER}")
                  }
                } 
            }
        }
        stage('Deploy to EKS') {
            steps {
                sh "export KUBECONFIG=${params.KUBECONFIG}"
                sh "cat api.yaml | sed -e 's/{{API_IMAGE}}/$API_IMAGE/g' |kubectl apply -f -"
                sh "cat web.yaml | sed -e 's/{{WEB_IMAGE}}/$WEB_IMAGE/g' |kubectl apply -f -"
            }
        }

    }
}
