pipeline {
    agent { label 'master' }

    environment {
        IMAGE_NAME = 'jenkins-builder'
        IMAGE_VERSION = "1.1"
        SCAN_REGISTRY = "sentinel:5001"
        APPROVED_REGISTRY = "sentinel:5000"
    }

    stages {
        stage('Build Image') {
            steps {
                script {
                    def customImage = docker.build("${env.IMAGE_NAME}:${env.IMAGE_VERSION}.${env.BUILD_NUMBER}", "--network host --no-cache .")
                    docker.withRegistry('https://${env.SCAN_REGISTRY}') {
                        customImage.push()
                    }
                }
            }
        }

        stage('Scan Image') {
            steps {
                sh 'echo "${SCAN_REGISTRY}/${IMAGE_NAME}:${IMAGE_VERSION}.${BUILD_NUMBER} Dockerfile" > anchore_images'
                anchore 'anchore_images'
            }
        }

        stage('Push Image') {
            steps {
                script {
                    def customImage = docker.image("${env.IMAGE_NAME}:${ENV.IMAGE_VERSION}.${env.BUILD_NUMBER}")
                    docker.withRegistry('https://${env.APPROVED_REGISTRY}') {
                        customImage.push()
                        customImage.push('latest')
                    }
                }
            }
        }
    }
}