pipeline {
    agent any

    stages {
        stage('Build Image') {
            steps {
                script {
                    def customImage = docker.build("jenkins-builder:1.1.${env.BUILD_NUMBER}", "--network host --no-cache .")
                    docker.withRegistry('https://sentinel:5001') {
                        customImage.push()
                    }
                }
            }
        }

        stage('Scan Image') {
            steps {
                sh 'echo "sentinel:5001/jenkins-builder:1.1.${env.BUILD_NUMBER} Dockerfile" > anchore_images'
                anchore 'anchore_images'
            }
        }

        stage('Push Image') {
            steps {
                def customImage = docker.image("jenkins-builder:1.1.${env.BUILD_NUMBER}")
                docker.withRegistry('https://sentinel:5000') {
                    customImage.push()
                    customImage.push(('latest')
                }
            }
        }
    }
}