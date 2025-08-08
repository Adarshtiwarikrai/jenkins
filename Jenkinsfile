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
    environment {
        KUBECONFIG = '/root/.kube/config' 
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
                        docker build -t "$DOCKER_USER/my-app:$BUILD_NUMBER" .
                    '''
                }
            }
        }

        stage('Docker Build') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhubpassword', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                    '''
                }
            }
        }

        stage('Docker Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhubpassword', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        docker push "$DOCKER_USER/my-app:$BUILD_NUMBER"
                    '''
                }
            }
        }

        stage('Checkout Kubernetes Repo') {
            steps {
                git(branch: 'main', url: 'https://github.com/Adarshtiwarikrai/kubernetes.git')
            }
        }

        stage('Update Image in Manifest') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhubpassword', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        sed -i "s|image: adarshtiwari34/my-app:.*|image: $DOCKER_USER/my-app:$BUILD_NUMBER|" manifest2.yaml
                    '''
                }
            }
        }

        stage('GKE Auth & Deploy') {
            steps {
                withCredentials([file(credentialsId: 'gke-service-account_one', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                    sh '''
                        export PATH=$PATH:/google-cloud-sdk/bin:/usr/local/bin

                        echo "gcloud version:"
                        gcloud version

                        echo "Activating service account..."
                        gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS

                        echo "Getting GKE credentials..."
                        gcloud container clusters get-credentials autopilot-cluster-1 \
                            --region us-central1 \
                            --project vertical-cirrus-465805-s7

                        echo "Deploying to Kubernetes..."
                        kubectl apply -f manifest2.yaml
                        kubectl apply -f manifest3.yaml

                        echo "Listing pods..."
                        kubectl get pods --all-namespaces
                    '''
                }
            }
        }
    }

    post {
        success {
            emailext(
                subject: "✅ Build Success: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: """<p>The build completed successfully.</p>
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
