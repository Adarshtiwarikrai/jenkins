pipeline {
    agent any
    tools {
       nodejs 'node 20.0.0' 
    }
    stages {
        stage('Build') { 
            steps {
                sh 'npm install' 
                sh 'npm run dev'
            }
        }
    }
}