pipeline {
    agent any

    tools {
       'jenkins.plugins.nodejs.tools.NodeJSInstallation' 'node 20.0.0'
    }

    stages {
        stage('Build') { 
            steps {
                sh 'npm install' 
                sh 'npm run build'
            }
        }
    }

    post {
        success {
            emailext(
                subject: "✅ Build Success: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: """<p>The build completed and and successfully.</p>
                         <p><a href="${env.BUILD_URL}">View Build</a></p>""",
                to: "adarshtiwari7799@gmail.com"
            )
        }
        failure {
            emailext(
                subject: "❌ Build Failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: """<p>The build failed.</p>
                         <p><a href="${env.BUILD_URL}">Check logs</a></p>""",
                to: "recipient@gmail.com"
            )
        }
    }
}

