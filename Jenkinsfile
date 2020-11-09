pipeline {
environment {
registry = "anorum/udacitycapstone"
registryCredential = 'anorum'
dockerImage = ''
}
  agent any
  stages {

      stage('Lint the website') {
          steps {
              sh '''
              tidy -q -e *.html
              '''
          }
      }
        stage('Building our image') {
        steps{
        script {
        dockerImage = docker.build registry + ":$BUILD_NUMBER"
        }
        }
        }
      stage('Deploy our image') {
        steps{
        script {
        docker.withRegistry( '', registryCredential ) {
        dockerImage.push()
        }
        }
        }
        }
}
}