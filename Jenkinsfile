pipeline {
    agent any

    stages {
        stage('Build') {
          steps {
            sh 'docker build -t radudobrinescu/image:api${env.BUILD_ID} ./node-3tier-app/api'
            sh 'docker build -t radudobrinescu/image:web${env.BUILD_ID} ./node-3tier-app/web'
            }
        stage('Test') {
            steps {
                echo 'Testing..'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}
