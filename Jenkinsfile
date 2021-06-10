pipeline {
    agent any
    
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub_id')
    }

    tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven "maven-3.8.1"
        jdk "openjdk-11"
    }

    stages {
        stage("Main branch") {
            when{
                branch 'main'
            }
            stages{
                stage('Checkout Stage app code') {
                    steps{
                        // Get application code from a GitHub repository
                        git branch: 'main',
                        credentialsId: '3837893b-13f7-4344-a864-b9fd63f5c96e',
                        url: 'https://github.com/MrThanasiz/toDoAppWithLogin.git'
                    }
                }
                
                stage("Compile") {
                    steps{
                        sh "pwd"
                        sh "ls"
                        // Run Maven on a Unix agent.
                        sh "mvn -Dmaven.test.failure.ignore=true clean package"
                    }
                    post {
                        // If Maven was able to run the tests, even if some of the test
                        // failed, record the test results and archive the jar file.
                        success {
                            junit '**/target/surefire-reports/TEST-*.xml'
                            archiveArtifacts 'target/*.jar'
                            sh "echo okayyy"
                            
                        }
                        failure {
                            mail bcc: '', body: '[prod] Failed to build commit!', 
                            cc: '', from: '', replyTo: '', 
                            subject: '[prod] Failed to build commit!', to: 'thanasiz99@gmail.com'
                        }
                    }
                }
                stage('docker build & push to dockerhub') {
                    steps{
                        /*script {
                            dockerImage = docker.build registry
                            docker.withRegistry( '', registryCredential ) {
                            dockerImage.push()
                            }
                        }*/
                        
                        sh "sudo docker build -t othanasiz/pf6_app:latest ."
                        sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                        sh "sudo docker push othanasiz/pf6_app:latest"
                    }
                    post {
                        always {
                        sh 'docker logout'
                        }
                        success {
                            sh "echo okayyy"
                        mail bcc: '', body: '[prod] Build, DockerHub upload Successful! Attempting to run', 
                        cc: '', from: '', replyTo: '', 
                        subject: '[prod] Build, DockerHub upload Successful!', to: 'thanasiz99@gmail.com'
                            
                        build 'ansibleRemoveApp'
                        build 'ansibleStartApp'
                            
                        }
                        failure {
                            sh "echo not okay"
                        mail bcc: '', body: 'Failed to upload to DockerHub!', 
                        cc: '', from: '', replyTo: '', 
                        subject: 'Failed to upload to DockerHub!', to: 'thanasiz99@gmail.com'
                        }
                    }
                }
            }
        }
        stage("Development branch"){
            when{
                branch 'development'
            }
            stages{
                stage('Checkout Stage app code') {
                    steps{
                        // Get application code from a GitHub repository
                        git branch: 'development',
                        credentialsId: '3837893b-13f7-4344-a864-b9fd63f5c96e',
                        url: 'https://github.com/MrThanasiz/toDoAppWithLogin.git'
                    }
                }
                
                stage("Compile") {
                    steps{
                        sh "pwd"
                        sh "ls"
                        // Run Maven on a Unix agent.
                        sh "mvn -Dmaven.test.failure.ignore=true clean package"
                    }
                    post {
                        // If Maven was able to run the tests, even if some of the test
                        // failed, record the test results and archive the jar file.
                        success {
                            junit '**/target/surefire-reports/TEST-*.xml'
                            archiveArtifacts 'target/*.jar'
                            sh "echo okayyy"
                            
                        }
                        failure {
                            mail bcc: '', body: '[dev] Failed to build commit!', 
                            cc: '', from: '', replyTo: '', 
                            subject: '[dev] Failed to build commit!', to: 'thanasiz99@gmail.com'
                        }
                    }
                }
                stage('docker build & push to dockerhub') {
                    steps{
                        /*script {
                            dockerImage = docker.build registry
                            docker.withRegistry( '', registryCredential ) {
                            dockerImage.push()
                            }
                        }*/
                        
                        sh "sudo docker build -t othanasiz/pf6_app:dev ."
                        sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                        sh "sudo docker push othanasiz/pf6_app:dev"
                    }
                    post {
                        always {
                        sh 'docker logout'
                        }
                        success {
                            sh "echo okayyy"
                        mail bcc: '', body: '[dev] Build, DockerHub upload Successful! Attempting to run', 
                        cc: '', from: '', replyTo: '', 
                        subject: '[dev] Build, DockerHub upload Successful!', to: 'thanasiz99@gmail.com'
                            
                        build 'ansibleRemoveAppDev'
                        build 'ansibleStartAppDev'
                            
                        }
                        failure {
                            sh "echo not okay"
                        mail bcc: '', body: '[dev] Failed to upload to DockerHub!', 
                        cc: '', from: '', replyTo: '', 
                        subject: '[dev] Failed to upload to DockerHub!', to: 'thanasiz99@gmail.com'
                        }
                    }
                }
            }
        }
        stage("PR branch"){
            when{
                branch 'PR**'
            }
            stages{
                stage("Testing"){
                    steps{
                        sh "mvn -Dmaven.test.failure.ignore=true clean package"
                    }
                    post{
                        always{
                            junit '**/target/surefire-reports/*.xml'
                        }
                        success {
                            mail bcc: '', body: 'New PR! Commit builds...', 
                            cc: '', from: '', replyTo: '', 
                            subject: 'New PR! Commit builds...', to: 'thanasiz99@gmail.com'
                        }
                        failure {
                            mail bcc: '', body: '[pr] Failed to build commit!', 
                            cc: '', from: '', replyTo: '', 
                            subject: '[pr] Failed to build commit!', to: 'thanasiz99@gmail.com'
                        }
                    }
                }
            }
        }  
    }
}
