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
                sh "aws ecs register-task-definition --cli-input-json file://fargate-task.json"
                sh "aws ecs describe-task-definition --task-definition ${params.TASKDEFNAME} --query 'taskDefinition.taskDefinitionArn' --output text > taskdefarn.txt"
            }
        }
        stage('Remove 1,1,2 ASG') {
            steps {
                sh "aws application-autoscaling deregister-scalable-target --service-namespace ecs --scalable-dimension ecs:service:DesiredCount --resource-id service/${params.CLUSTERNAME}/${params.SERVICE_NAME}"
            }
        }
        stage('Update ECS Infra ECS Service') {
            steps {
                script {
                    def TASKDEF_ARN = readFile(file: 'taskdefarn.txt')
                    echo "${TASKDEF_ARN}"
                    sh "aws ecs update-service --cluster ${params.CLUSTERNAME} --service ${params.SERVICE_NAME} --force-new-deployment --task-definition ${TASKDEF_ARN}"
                }
            }
        }
        stage('Double the AWS ASG to 2,2,4') {
            steps {
                sh "aws application-autoscaling register-scalable-target \
                    --service-namespace ecs \
                    --scalable-dimension ecs:service:DesiredCount \
                    --resource-id service/${params.CLUSTERNAME}/${params.SERVICE_NAME} \
                    --role-arn arn:aws:iam::734446176968:role/ecs-fargate-serviceAutoScalingRole \
                    --min-capacity 2 \
                    --max-capacity 4"
            }
        }
        stage('Describe ASG targets') {
            steps {
                sh "aws application-autoscaling describe-scalable-targets \
                --service-namespace ecs \
                --resource-ids service/${params.CLUSTERNAME}/${params.SERVICE_NAME}"
                sh "aws application-autoscaling describe-scaling-activities --service-namespace ecs --scalable-dimension ecs:service:DesiredCount --resource-id service/${params.CLUSTERNAME}/${params.SERVICE_NAME} --query 'ScalingActivities[1].StatusCode' --output text > ASGstatus.txt"
            }
        }
        stage('Describe ASG activities,check and scale functions') {
            steps {
                script {
                    def ASGStatus = readFile(file: 'ASGstatus.txt')
                    println(ASGStatus)
                    if ('${ASGStatus}' == 'Successful') {
                        sh "aws application-autoscaling deregister-scalable-target --service-namespace ecs --scalable-dimension ecs:service:DesiredCount --resource-id service/${params.CLUSTERNAME}/${params.SERVICE_NAME}"
                        sh "aws application-autoscaling register-scalable-target \
                            --service-namespace ecs \
                            --scalable-dimension ecs:service:DesiredCount \
                            --resource-id service/${params.CLUSTERNAME}/${params.SERVICE_NAME} \
                            --role-arn arn:aws:iam::734446176968:role/ecs-fargate-serviceAutoScalingRole \
                            --min-capacity 1 \
                            --max-capacity 2"
                    }else {
                        currentBuild.result = "UNSTABLE"
                    }
                }
            }
        }
}
