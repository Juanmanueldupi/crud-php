pipeline {
    agent none
    stages {
        stage ('Clonado') {
            agent {
                docker { image 'python:3.12'
                args '-u root:root'
                }
            }
            stages {
                stage('Clone') {
                    steps {
                        git branch:'main',url:'https://github.com/Juanmanueldupi/crud-php.git'
                    }
                }
            }
        }
        stage('Upload img') {
            agent any
            stages {
                stage('Build and push') {
                    steps {
                        script {
                            withDockerRegistry([credentialsId: 'DOCKER_HUB', url: '']) {
                            def dockerImage = docker.build("jmdpsysadmin/crudphp:${env.BUILD_ID}")
                            def imageName = dockerImage.imageId
                            dockerImage.push()
                            }
                        }
                    }
                }
                stage('Remove image') {
                    steps {
                        script {
                            sh "docker rmi jmdpsysadmin/crudphp:${env.BUILD_ID}"
                        }
                    }
                }
                stage ('SSH') {
                    steps{
                        sshagent(credentials : ['ssh_key']) {
                            sh 'ssh -o StrictHostKeyChecking=no debian@vps.jduranasir.site wget https://raw.githubusercontent.com/Juanmanueldupi/crud-php/main/docker-compose.yaml -O docker-compose.yaml'
                            sh 'ssh -o StrictHostKeyChecking=no debian@vps.jduranasir.site docker compose up -d --force-recreate'
                        }
                    }
                }
            }
        }
    }
    post {
        always {
            mail to: 'juanmadupi@gmail.com',
            subject: "Status of pipeline: ${currentBuild.fullDisplayName}",
            body: "${env.BUILD_URL} has result ${currentBuild.result} y la imagen se llama ${imageName}"
            }
        }
    }
