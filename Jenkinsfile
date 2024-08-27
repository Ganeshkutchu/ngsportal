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
        stage('Build an Artifact') {
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
                        nexusArtifactUploader artifacts: [[artifactId: 'Ngs-Job-Portal', classifier: '', file: 'target/Ngs-Job-Portal-0.0.1-SNAPSHOT.jar', type: 'jar']], credentialsId: 'Nexus_Credentials', groupId: 'in.ngs', nexusUrl: '13.126.14.152:8081', nexusVersion: 'nexus3', protocol: 'http', repository: 'Ngs_snapshot_repo', version: '1.0-SNAPSHOT'
                    }
                }
            }
        }
        stage('Build &&& Push Docker Image'){
            steps{
                script {
                    docker.withRegistry('',DOCKER_PASS) {
                        docker_image = docker.build "${IMAGE_NAME}"
                    }

                    docker.withRegistry('',DOCKER_PASS) {
                        docker_image.push("${IMAGE_TAG}")
                        docker_image.push('latest')
                    }
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
