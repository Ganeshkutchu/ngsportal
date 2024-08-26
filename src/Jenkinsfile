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
    }
}