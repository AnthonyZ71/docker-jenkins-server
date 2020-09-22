pipeline {
    agent any

    stages {
        stage('Build Image') {
            steps {
                script {
                    def customImage = docker.build("scanning-registry:5000/jenkins-builder:1.1.${env.BUILD_NUMBER}", "--network host --no-cache .")
                    docker.withRegistry('scanning-registry:5000') {
                        customImage.push()
                    }
                }
            }
        }

        stage('Scan Image') {
            sh 'echo "scanning-registry:5000/jenkins-builder:1.1.${env.BUILD_NUMBER} Dockerfile" > anchore_images'
            anchore 'anchore_images'
        }

        
    }
}