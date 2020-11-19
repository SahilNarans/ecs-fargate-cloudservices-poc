def getDevVersion() {
    script {
        return sh(script: "aws s3 cp s3://ecs-fargate-cloudservices-poc-s3-bucket/version.txt .; cat version.txt", returnStdout: true)
    }
}

pipeline {
    agent any
    environment {
        DEV_VERSION = getDevVersion()
    }
    parameters {
        text(name: 'DEVAWSACCOUNTID', defaultValue: '734446176968', description: 'Enter the AWS Account ID, where to push image to ECR')

        text(name: 'DEVWSACCOUNTREGION', defaultValue: 'us-east-1', description: 'Enter the DEV AWS Account Region')

        string(name: 'DEVREPOSITORYNAME', defaultValue: 'ecs-fargate-cloudservices-poc-repo', description: 'Enter the AWS ECR DEV Repo name to create n push the image')
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
        stage('SBT Build') {
            steps {
                println "***********************************OLDER_VERSION version is ${env.DEV_VERSION}"
                echo 'Build steps are in progress!!!'
                sh '''SBT_VERSION=1.3.13
                      sbt test
                      sbt stage
                   '''
            }
        }
        stage('ECR Login Stage') {
            steps {
                echo 'Login into the DEV Account ECR'
                sh "aws ecr get-login-password --region ${params.DEVWSACCOUNTREGION} | tail -n +1 | sudo docker login --username AWS --password-stdin  ${params.DEVAWSACCOUNTID}.dkr.ecr.${params.DEVWSACCOUNTREGION}.amazonaws.com"
            }
        }
        stage('Docker Build') {
            steps {
                echo 'Build the Docker Image'
                sh "sudo docker build -t ${params.DEVREPOSITORYNAME} . "
            }
        }
        stage('Versioning') {
            steps {
                
                echo 'Bumping up the version'
                sh "sudo bash set_version.sh version.txt"
            } 
        }
        // stage('Git Checkout 2') {
        //     steps {
        //         git branch: 'master',
        //             credentialsId: 'neerajgulia92github',
        //             url: 'https://github.com/neerajgulia92/ecs-fargate-cloudservices-poc.git'

        //         sh "ls -lat"
        //     }
        // }
        stage('Docker Tag and Push Stage') {
            steps {
                script {
                    def DEVIMAGE_TAG = readFile(file: 'version.txt')
                    println(DEVIMAGE_TAG)
                    echo 'Tag and Push the Docker Image to ECR'
                    sh "sudo docker tag ${params.DEVREPOSITORYNAME} ${params.DEVAWSACCOUNTID}.dkr.ecr.${params.DEVWSACCOUNTREGION}.amazonaws.com/${params.DEVREPOSITORYNAME}:${DEVIMAGE_TAG}"
                    sh "sudo docker push ${params.DEVAWSACCOUNTID}.dkr.ecr.${params.DEVWSACCOUNTREGION}.amazonaws.com/${params.DEVREPOSITORYNAME}:${DEVIMAGE_TAG}"
                    withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'neerajgulia92github', usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_PASSWORD']]) {
                        sh "git tag v${DEVIMAGE_TAG}"
                        sh "git push https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/neerajgulia92/ecs-fargate-cloudservices-poc.git v${DEVIMAGE_TAG}"
                        // sh "git push https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/neerajgulia92/ecs-fargate-cloudservices-poc.git"
                }
            }
        }
        }
        stage('Update Version file on S3'){
            steps {
                script {
                    sh "aws s3 cp version.txt s3://ecs-fargate-cloudservices-poc-s3-bucket/version.txt"
                }
            }
        }
     }
}