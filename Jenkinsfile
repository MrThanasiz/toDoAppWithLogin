pipeline{
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub_id')
    }

    tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven "maven-3.8.1"
        jdk "openjdk-11"
    }
    stages{
        stage("Main branch"){
            when{
                branch 'main'
            }
            stages{
                stage("Input message"){
                    input{
                        message "Do you want to deploy?"
                        ok "Yes!"
                        parameters{
                            string(name:'OUTPUT', defaultValue:'',description:"Enter a text")
                        }
                    }
                    steps{
                        echo "The output is: ${OUTPUT}"
                    }
                }
                stage("Deploy to Prod"){
                    steps{
                        echo "I deployed to production"
                        //here run pipeline commit2dockerimage
                        //and ansibleRemoveApp
                        //ansibleStartApp
                    }
                }
            }
            post{
                success{
                    mail to:"thanasiz99@gmail.com",
                    subject:"SUCCESSFUL BUILD: $BUILD_TAG",
                    body:"Link to JOB $BUILD_URL"
                }
                failure{
                    mail to:"thanasiz99@gmail.com",
                    subject:"FAILURE BUILD: $BUILD_TAG",
                    body:"Link to JOB $BUILD_URL"
                }
            }
        }
        stage("Development branch"){
            when{
                branch 'development'
            }
            stages{
                stage("Deploy to Dev"){
                    steps{
                        //here run pipeline commit2dockerimage
                        //and ansibleRemoveApp
                        //ansibleStartApp
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
                    }
                }
            }
        }
    }
}