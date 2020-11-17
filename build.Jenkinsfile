pipeline {
    agent any     
    parameters {
        text(name: 'DEVAWSACCOUNTID', defaultValue: '365638482223', description: 'Enter the AWS Account ID, where to push image to ECR')

        text(name: 'DEVWSACCOUNTREGION', defaultValue: 'us-east-1', description: 'Enter the DEV AWS Account Region')

        string(name: 'DEVREPOSITORYNAME', defaultValue: 'ecs-fargate-cloudservices-poc-repo', description: 'Enter the AWS ECR DEV Repo name to create n push the image')
    }
    stages {
        stage('SBT Build') {
            steps {
                echo 'Build steps are in progress!!!'
                sh '''SBT_VERSION=1.3.13
                      sbt test
                      sbt run
                      curl localhost:9000/live
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
        // stage('Versioning') {
        //     steps {
                
        //         echo 'Bumping up the version'
        //         sh "sudo bash test_set_version.sh dev_version.txt"
        //     } 
        // }
        stage('Docker Tag and Push Stage') {
            steps {
                script {
                    def DEVIMAGE_TAG = 'latest'
                    println(DEVIMAGE_TAG)
                    echo 'Tag and Push the Docker Image to ECR'
                    sh "sudo docker tag ${params.DEVREPOSITORYNAME} ${params.DEVAWSACCOUNTID}.dkr.ecr.${params.DEVWSACCOUNTREGION}.amazonaws.com/${params.DEVREPOSITORYNAME}:${DEVIMAGE_TAG}"
                    sh "sudo docker push ${params.DEVAWSACCOUNTID}.dkr.ecr.${params.DEVWSACCOUNTREGION}.amazonaws.com/${params.DEVREPOSITORYNAME}:${DEVIMAGE_TAG}"
                //     withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: '44113e51-abaf-4098-8718-f6cd752b17f8', usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_PASSWORD']]) {
                //         sh "git tag v${DEVIMAGE_TAG}"
                //         sh "git push https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/gvenkat1216/automated-dev-update-poc.git v${DEVIMAGE_TAG}"
                // }
                }
            }
        }
        // stage('Update Version file on S3'){
        //     steps {
        //         script {
        //             sh "aws s3 cp dev_version.txt s3://versioning-skechers01/dev_version.txt"
        //         }
        //     }
        // }
        // stage('Update Version file on S3'){
        //     steps {
        //         script {
        //             sh "aws s3 cp dev_version.txt s3://versioning-skechers01/dev_version.txt"
        //         }
        //     }
        // }
     }
}