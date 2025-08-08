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

// pipeline {
//     agent any
    
//     tools {
//         nodejs 'node 20.0.0'  
//     }
//     environment {
//         KUBECONFIG = '/root/.kube/config' 
//     }

//     stages {
//     stage('Build') {
//             steps {
//                 sh 'npm install'
//                 sh 'npm run build'
//             }
//         }
//     stage('Docker Login') {
//         steps{
//             withCredentials([usernamePassword(credentialsId: 'dockerhubpassword', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
//                 sh '''
//                      docker build -t "$DOCKER_USER/my-app:$BUILD_NUMBER" .
//                    '''
//             }
           
        
//         }
        
//     }
//     stage ('docker build'){
//         steps {
//             withCredentials([usernamePassword(credentialsId: 'dockerhubpassword', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
//                 sh '''
//                    echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
//                    '''
//             }
//         }
//     }
//     stage ('docker push'){
//          steps {
//                 withCredentials([usernamePassword(credentialsId: 'dockerhubpassword', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
//                     sh '''
//                         docker push "$DOCKER_USER/my-app:$BUILD_NUMBER"
//                     '''
//                 }
//             }
//     }
//     stage('Build second') {
//             steps {
//         git(branch: 'main', url: 'https://github.com/Adarshtiwarikrai/kubernetes.git')
//     }
//     }
//     stage('pull'){
//         steps {
//         withCredentials([usernamePassword(credentialsId: 'dockerhubpassword', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
//             sh '''
//                 sed -i "s|image: adarshtiwari34/my-app:.*|image: $DOCKER_USER/my-app:$BUILD_NUMBER|" manifest2.yaml
//             '''
//         }
//     }
//     }
//     stage('kubectl '){
        
//         steps{
//            sh '''
//             export KUBECONFIG=/root/.kube/config  # Adjust path if needed
//             which kubectl
//             kubectl get pods
//           '''
//         }
//     }
//     }
   
//     post {
//         success {
//             emailext(
//                 subject: "✅ Build Success: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
//                 body: """<p>The build completed and and and and  andsuccessfullly.</p>
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

    environment {
        GOOGLE_APPLICATION_CREDENTIALS = credentials('gke-service-account') // Jenkins secret file ID
        PROJECT_ID = 'vertical-cirrus-465805-s7'
        CLUSTER_NAME = 'autopilot-cluster-1'
        CLUSTER_ZONE = 'us-central1'
    }

    stages {
        stage('Connect to GKE') {
            steps {
                sh '''
                    echo "Activating service account..."
                    gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS

                    echo "Setting project..."
                    gcloud config set project $PROJECT_ID

                    echo "Getting cluster credentials..."
                    gcloud container clusters get-credentials $CLUSTER_NAME --zone $CLUSTER_ZONE --project $PROJECT_ID
                '''
            }
        }

        stage('Get Pods') {
            steps {
                sh 'kubectl get pods --all-namespaces'
            }
        }
    }
}
