pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        AWS_DEFAULT_REGION = 'us-east-1'
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
            steps { sh 'mvn clean package' }
        }

        stage('Docker Build') {
            steps { sh 'docker build -t $IMAGE_NAME:$IMAGE_TAG .' }
        }

        stage('Trivy Scan') {
            steps { sh 'trivy image $IMAGE_NAME:$IMAGE_TAG' }
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
            steps { sh 'docker push $IMAGE_NAME:$IMAGE_TAG' }
        }

        stage('Deploy to EKS') {
            steps {
                sh '''
                aws eks --region $AWS_DEFAULT_REGION update-kubeconfig --name devops-cluster
                kubectl apply -f deployment.yaml
                '''
            }
        }
    }
}
