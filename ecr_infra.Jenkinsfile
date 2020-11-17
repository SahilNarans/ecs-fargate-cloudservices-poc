pipeline {
    agent any
    parameters {
        string(name: 'ECR_CFTSTACKNAME', defaultValue: 'ecs-fargate-cloudservices-poc-repo', description: 'Enter the AWS CFT Stack Name')

        choice(choices: ['dev' , 'staging'], description: 'Choose a deployment environment.', name: 'DEPLOY_ENV')
    
        string(name: 'DEV_REPOSITORYNAME', defaultValue: 'ecs-fargate-cloudservices-poc-repo', description: 'Enter the AWS DEV ECR Repo name to create n push the image')
    }
    stages {
        // stage('Git Checkout') {
        //     steps {
        //         git branch: 'master',
        //             credentialsId: 'neerajgulia92github',
        //             url: 'https://github.com/neerajgulia92/ecs-fargate-cloudservices-poc.git'

        //         sh "ls -lat"
        //     }
        // }
        stage('Create ECR Infra stack for dev') {
            steps {
                sh "aws cloudformation create-stack --stack-name ${params.ECR_CFTSTACKNAME} --template-body file://CF_ProdECR.yaml --region 'us-east-1' --parameters ParameterKey=RepositoryName,ParameterValue=${params.DEV_REPOSITORYNAME} --capabilities CAPABILITY_NAMED_IAM"
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