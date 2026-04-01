pipeline {
    agent any

    environment {
        IMAGE_NAME = "ashutosh6370/devops-java-app-p2-enhanced"
        IMAGE_TAG = "v1"
    }

    tools {
        maven 'Maven3.8.7'
        jdk 'JDK17'
    }

    stages {

        stage('Checkout') {
            steps {
                deleteDir()
                git branch: 'main', url: 'https://github.com/Ashutosh6370/devops-java-app-p2-enhanced.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t $IMAGE_NAME:$IMAGE_TAG .'
            }
        }

        stage('Trivy Scan') {
            steps {
                sh 'trivy image $IMAGE_NAME:$IMAGE_TAG'
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'USER',
                    passwordVariable: 'PASS'
                )]) {
                    sh 'echo $PASS | docker login -u $USER --password-stdin'
                }
            }
        }

        stage('Push Image') {
            steps {
                sh 'docker push $IMAGE_NAME:$IMAGE_TAG'
            }
        }

        stage('Deploy to EKS') {
            steps {
                withAWS(region: 'us-east-1', credentials: 'aws-eks-creds') {
                    sh 'aws eks --region us-east-1 update-kubeconfig --name devops-cluster'
                    sh 'kubectl apply -f deployment.yaml'
                }
            }
        }
    }
}
