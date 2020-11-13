pipeline {
    agent any
    parameters {
        string(name: 'CFTSTACKNAME', defaultValue: 'ecs-fargate-cloudservices-poc', description: 'Enter the AWS CFT Stack Name')

        string(name: 'ECR_CFTSTACKNAME', defaultValue: 'ecs-fargate-cloudservices-poc-repo', description: 'Enter the AWS CFT Stack Name')

        text(name: 'AWSACCOUNTID', defaultValue: '', description: 'Enter the AWS Account ID, where to push image to ECR')

        choice(choices: ['TRUE' , 'FALSE'],description: 'Infrastructure Stack Required True or False',name: 'INFRA_REQUESTED_ACTION')

        choice(choices: ['dev' , 'staging'], description: 'Choose a deployment environment.', name: 'DEPLOY_ENV')
    
        string(name: 'REPOSITORYNAME', defaultValue: 'ecs-fargate-cloudservices-poc-repo', description: 'Enter the AWS ECR Repo name to create n push the image')

        string(name: 'CLUSTERNAME', defaultValue: 'ecs-fargate-cloudservices-poc-cluster', description: 'Enter the AWS ECS cluster name')

        string(name: 'TASKDEFNAME', defaultValue: 'ecs-fargate-cloudservices-poc-taskdef', description: 'Enter the AWS ECS Task Definition Name')

        string(name: 'CONTAINERNAME', defaultValue: 'ecs-fargate-cloudservices-poc-container', description: 'Enter the AWS ECS Task Definition Container Name')

        string(name: 'VPC_ID', defaultValue: '', description: 'Enter the AWS VPC ID')

        string(name: 'SUBNET_A', defaultValue: '', description: 'Enter the AWS Subnet_A ID')

        string(name: 'SUBNET_B', defaultValue: '', description: 'Enter the AWS Subnet_B ID')

        string(name: 'SECURITY_GROUP_NAME', defaultValue: 'ECSbatchprocessingSecurityGroup', description: 'Enter the AWS SECURITY_GROUP_NAME')

        string(name: 'ECSEVENTROLENAME', defaultValue: 'ecsRunTaskRole', description: 'Enter the AWS IAM ECS Event Role Name')

        string(name: 'ECSTASKEXECUTIONROLENAME', defaultValue: 'ecsTaskExecutionRole', description: 'Enter the AWS IAM ECS Task Execution Role')

        string(name: 'SERVICE_NAME', defaultValue: 'ecs-fargate-service', description: 'Enter the ECS Service name')
    }
    stages {
        stage('Create ECR Infra stack') {
            when {
                // Only set to true if infrastructure is requested
                expression { params.INFRA_REQUESTED_ACTION == 'TRUE' }
            }
            steps {
                sh "aws cloudformation create-stack --stack-name ${params.ECR_CFTSTACKNAME} --template-body file://CF_ProdECR.yaml --region 'us-east-1' --parameters ParameterKey=RepositoryName,ParameterValue=${params.REPOSITORYNAME} --capabilities CAPABILITY_NAMED_IAM"
            }
        }
        stage('Check ECR Infra stack status') {
            steps {
                sh "aws cloudformation describe-stacks --stack-name ${params.ECR_CFTSTACKNAME} --query 'Stacks[0].StackStatus' --output text"
            }
        }
        stage('To wait for CloudFormation to finish creating a ECR Infra stack') {
            steps {
                sh "aws cloudformation wait stack-create-complete --stack-name ${params.ECR_CFTSTACKNAME}"
            }
        }
    }
}