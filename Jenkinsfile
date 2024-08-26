pipeline {
    agent any
    
    tools {
        maven 'maven3.9.8' // Use the Maven tool configured globally
    }

     stages {
        stage('Cleanup Workspace') {
            steps {
                cleanWs()
            }
        }
        stage('clone Git Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/Ganeshkutchu/ngsportal.git'
            }
        }
    
        stage('Build an artifact'){
            steps{
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
                        nexusArtifactUploader artifacts: [[artifactId: 'Ngs-Job-Portal', classifier: '', file: 'target/Ngs-Job-Portal-0.0.1-SNAPSHOT.jar', type: 'jar']], credentialsId: 'Nexus_Credentials', groupId: 'in.ngs', nexusUrl: '13.234.20.104', nexusVersion: 'nexus3', protocol: 'http', repository: 'Ngs_JobPortal_Repo', version: '1.0-SNAPSHOT'
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
                to: 'rambasai4@gmail.com', 
                attachLog: true, 
                recipientProviders: [[$class: 'DevelopersRecipientProvider']] 
            ) 
        } 
        failure { 
            emailext ( 
                subject: "FAILURE: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'", 
                body: "The build failed. Check the details at: ${env.BUILD_URL}/pipeline-graph/", 
                to: 'rambasai4@gmail.com', 
                attachLog: true, 
                recipientProviders: [[$class: 'DevelopersRecipientProvider']]         
            ) 
        } 
    } 
}