pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'your_docker_image_name'
        AWS_REGION = 'your_aws_region'
        AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        EC2_INSTANCE_IP = 'your_ec2_instance_ip'
        SSH_KEY = credentials('ssh-key-id')
    }

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}")
                }
            }
        }

        stage('Push Docker Image to AWS ECR') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'aws-ecr-credentials', variable: 'AWS_ECR_CREDENTIALS')]) {
                        docker.withRegistry("https://${AWS_REGION}.dkr.ecr.${AWS_REGION}.amazonaws.com", "${AWS_ECR_CREDENTIALS}") {
                            docker.image("${DOCKER_IMAGE}").push()
                        }
                    }
                }
            }
        }

        stage('Deploy Docker Image to EC2') {
            steps {
                script {
                    sh "ssh -i ${SSH_KEY} ec2-user@${EC2_INSTANCE_IP} 'docker pull ${DOCKER_IMAGE}'"
                    sh "ssh -i ${SSH_KEY} ec2-user@${EC2_INSTANCE_IP} 'docker run -d -p 80:80 ${DOCKER_IMAGE}'"
                }
            }
        }
    }
}
