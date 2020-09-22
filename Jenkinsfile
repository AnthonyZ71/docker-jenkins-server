pipeline {
    agent any

    stages {
        stage('Build Image') {
            steps {
                script {
                    def customImage = docker.build("jenkins-builder:1.1.${env.BUILD_NUMBER}", "--network host --no-cache .")
                    docker.withRegistry('https://scanning-registry:5000') {
                        customImage.push()
                    }
                }
            }
        }

        stage('Scan Image') {
            steps {
                sh 'echo "scanning-registry:5000/jenkins-builder:1.1.${env.BUILD_NUMBER} Dockerfile" > anchore_images'
                anchore 'anchore_images'
            }
        }


    }
}