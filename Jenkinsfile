pipeline {
    agent any

    stages {
        stage('Build') {
          steps {
            sh 'docker build -f /node-3tier-app/api/Dockerfile -t radudobrinescu/image:api /node-3tier-app/api'
            sh 'docker build -t radudobrinescu/image:web -f /node-3tier-app/web/Dockerfile /node-3tier-app/web'
            }
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
