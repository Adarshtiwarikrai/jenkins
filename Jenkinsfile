// pipeline {
//     agent { label 'gcp-agent' }  

//     tools {
//         nodejs 'node 20.0.0'  
//     }

//     stages {
//         stage('Build') {
//             steps {
//                 sh 'npm install'
//                 sh 'npm run build'
//             }
//         }
//     }

//     post {
//         success {
//             emailext(
//                 subject: "✅ Build Success: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
//                 body: """<p>The build completed and successfully.</p>
//                          <p><a href="${env.BUILD_URL}">View Build</a></p>""",
//                 to: "adarshtiwari7799@gmail.com"
//             )
//         }
//         failure {
//             emailext(
//                 subject: "❌ Build Failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
//                 body: """<p>The build failed.</p>
//                          <p><a href="${env.BUILD_URL}">Check logs</a></p>""",
//                 to: "recipient@gmail.com"
//             )
//         }
//     }
// }

pipeline {
    agent any
    
    tools {
        nodejs 'node 20.0.0'  
    }

    stages {
        stage('Build') {
            steps {
                sh 'npm install'
                sh 'npm run build'
            }
        }
    
    
    stage('Docker Login') {
        steps {
            withCredentials([usernamePassword(credentialsId: 'dockerhubpassword', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                sh '''
                   echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                   '''
            }
        }
    }
    stage ('docker build'){
        steps{
            withCredentials([usernamePassword(credentialsId: 'dockerhubpassword', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                sh '''
                     docker build -t "$DOCKER_USER/my-app:$BUILD_NUMBER"
                   '''
            }
           
        
        }
    }
    }
   
    post {
        success {
            emailext(
                subject: "✅ Build Success: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: """<p>The build completed and and successfullly.</p>
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
