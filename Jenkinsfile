pipeline {
    agent { label 'slave-1' } // Run the job on the node labeled 'slave-1'
    
    tools {
        maven 'maven3.9.8' // Use the Maven tool configured globally
    }
    environment {
	        APP_NAME = "ngs-jobportal"
            RELEASE = "1.0.0"
            DOCKER_USER = "ganesh8195"
            DOCKER_PASS = 'dockerhub'
            IMAGE_NAME = "${DOCKER_USER}" + "/" + "${APP_NAME}"
            IMAGE_TAG = "${RELEASE}-${BUILD_NUMBER}"
	        JENKINS_API_TOKEN = credentials("JENKINS_API_TOKEN")
    }

    stages {
        stage('Cleanup Workspace') {
            steps {
                cleanWs()
            }
        }
        stage('Clone Git Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/Ganeshkutchu/ngsportal.git'
            }
        }
        stage('Build an Artifacts') {
            steps {
                sh 'mvn clean package'
            }
        }
        stage('Parallel Stages') {
            parallel {
                stage('SonarQube Analysis') {
                    steps {
                        withSonarQubeEnv('sonarQube') {
                            sh 'mvn sonar:sonar'
                        }
                    }
                }
        stage('Upload Build Artifact') {
                    steps {
                        nexusArtifactUploader artifacts: [[artifactId: 'Ngs-Job-Portal', classifier: '', file: 'target/Ngs-Job-Portal-0.0.1-SNAPSHOT.jar', type: 'jar']], credentialsId: 'Nexus_Credentials', groupId: 'in.ngs', nexusUrl: '13.201.85.126:8081', nexusVersion: 'nexus3', protocol: 'http', repository: 'Ngs_snapshot_repo', version: '1.0-SNAPSHOT'
                    }
                }
            }
        }
        stage('Build Docker Image'){
            steps{
                script {
                    docker.withRegistry('',DOCKER_PASS) {
                    docker_image = docker.build "${IMAGE_NAME}"
                    }
                }

            }

        }
        stage('Multi Stages'){
            parallel {
                stage('push docker image to DockerHub'){
                    steps{
                        script{
                            docker.withRegistry('',DOCKER_PASS) {
                            docker_image.push("${IMAGE_TAG}")
                            docker_image.push('latest')
                    }
                        }
                    }
                }
            stage('push docker image to AWS ECR'){
                steps{
                    script{
                       sh 'aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/q2v7l2n8'
                       sh 'docker tag ganesh8195/ngs-jobportal:latest public.ecr.aws/q2v7l2n8/ganesh8195/ngs-jobportal:${IMAGE_TAG}'
                       sh 'docker push public.ecr.aws/q2v7l2n8/ganesh8195/ngs-jobportal:${IMAGE_TAG}'
                    }
                }
            }
        }
        }
       stage ('Cleanup docker images') {
           steps {
               script {
                    sh "docker rmi ${IMAGE_NAME}:${IMAGE_TAG}"
                    sh "docker rmi ${IMAGE_NAME}:latest"
               }
          }
       }
       stage("Trigger CD Pipeline") {
            steps {
                script {
                    sh "curl -v -k --user ganesh:${JENKINS_API_TOKEN} -X POST -H 'cache-control: no-cache' -H 'content-type: application/x-www-form-urlencoded' --data 'IMAGE_TAG=${IMAGE_TAG}' 'ec2-13-127-105-197.ap-south-1.compute.amazonaws.com:8080/job/NgsJobPortal-cd/buildWithParameters?token=github'"
                }
            }
       }
    }
    post { 
        success { 
            emailext ( 
                subject: "SUCCESS: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'", 
                body: "The build succeeded. Check the details at: ${env.BUILD_URL}/pipeline-graph/", 
                to: 'kutchugovi@gmail.com', 
                attachLog: true, 
                recipientProviders: [[$class: 'DevelopersRecipientProvider']] 
            ) 
        } 
        failure { 
            emailext ( 
                subject: "FAILURE: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'", 
                body: "The build failed. Check the details at: ${env.BUILD_URL}/pipeline-graph/", 
                to: 'kutchugovi@gmail.com', 
                attachLog: true, 
                recipientProviders: [[$class: 'DevelopersRecipientProvider']]         
            ) 
        } 
    } 
}
