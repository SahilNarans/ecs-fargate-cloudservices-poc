def getDevVersion() {
    script {
        return sh(script: "aws s3 cp s3://ecs-fargate-cloudservices-poc-s3-bucket/version.txt .; cat version.txt", returnStdout: true)
    }
}

def imagetag() {
    script {
        return sh (script: 'cat version.txt | tail -n 1 | tr -cd "0-9\\."', returnStdout: true)
    }
}

pipeline {
    agent any
    environment {
        ECR_IMAGE_VERSION = getDevVersion()
        IMAGE_TAG = imagetag()
    }
    parameters {
        string(name: 'CLUSTERNAME', defaultValue: 'ecs-fargate-cloudservices-poc-cluster', description: 'Enter the AWS ECS cluster name')

        string(name: 'TASKDEFNAME', defaultValue: 'ecs-fargate-cloudservices-poc-taskdef', description: 'Enter the AWS ECS Task Definition Name')

        string(name: 'SERVICE_NAME', defaultValue: 'ecs-fargate-service', description: 'Enter the ECS Service name')
    }
    stages {
        stage('Update ECS Task Definition JSON File') {
            steps {
                echo "${env.ECR_IMAGE_VERSION}"
                echo "${env.IMAGE_TAG}"
                sh "sed -i 's/imagetag/${env.IMAGE_TAG}/g' ./fargate-task.json"
            }
        }
        stage('Update ECS Task Definition') {
            steps {
                // sh "aws ecs register-task-definition --cli-input-json file://fargate-task.json"
                sh "aws ecs describe-task-definition --task-definition ${params.TASKDEFNAME} --query 'taskDefinition.taskDefinitionArn' --output text > taskdefarn.txt"
            }
        }
        stage('Check ECS Infra stack status') {
            steps {
                script {
                    def TASKDEF_ARN = sh(script: 'cat taskdefarn.txt | tail -n 1')
                    println(TASKDEF_ARN)
                    echo "${TASKDEF_ARN}"
                    // sh "aws ecs update-service --cluster ${params.CLUSTERNAME} --service ${params.SERVICE_NAME} --task-definition ${TASKDEF_ARN} --force-new-deployment"
                }
            }
        }
    }
}