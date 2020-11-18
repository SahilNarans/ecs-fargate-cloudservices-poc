def getDevVersion() {
    script {
        return sh(script: "aws s3 cp s3://ecs-fargate-cloudservices-poc-s3-bucket/version.txt .; cat version.txt", returnStdout: true)
    }
}

pipeline {
    agent any
    environment {
        ECR_IMAGE_TAG = getDevVersion()
    }
    parameters {
        string(name: 'CLUSTERNAME', defaultValue: 'ecs-fargate-cloudservices-poc-cluster', description: 'Enter the AWS ECS cluster name')

        string(name: 'SERVICE_NAME', defaultValue: 'ecs-fargate-service', description: 'Enter the ECS Service name')
    }
    stages {
        stage('Update ECS Task Definition JSON File') {
            steps {
                sh """
                sed -i "s/"image": "734446176968.dkr.ecr.us-east-1.amazonaws.com/ecs-fargate-cloudservices-poc-repo:1.0.0"\$/"image": "734446176968.dkr.ecr.us-east-1.amazonaws.com/ecs-fargate-cloudservices-poc-repo:{env.ECR_IMAGE_TAG}"/"
                """
            }
        }
        stage('Update ECS Task Definition') {
            steps {
                sh "aws ecs register-task-definition --cli-input-json file://fargate-task.json"
            }
        }
        stage('Check ECS Infra stack status') {
            steps {
                sh "aws ecs update-service --cluster ${params.CLUSTERNAME} --service ${params.SERVICE_NAME} --force-new-deployment"
            }
        }
    }
}