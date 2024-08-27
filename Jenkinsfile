pipeline {
    agent { label 'slave-1' } // Run the job on the node labeled 'slave-1'
    
    tools {
        maven 'maven3.9.8' // Use the Maven tool configured globally
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
                        echo 'upload sucess'
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
