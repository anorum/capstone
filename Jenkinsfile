pipeline {
  agent any
  stages {

      stage('Lint the website') {
          steps {
              sh '''
              tidy -q -e *.html
              '''
          }
      }
      stage('Build the Docker Image') {
          steps {
              sh '''
              docker build -t anorum/udacitycapstone:latest .
              '''
          }
      }
      stage('Publish the Docker Image') {
          steps {
              sh '''
              docker push anorum/udacitycapstone
              '''
          }
      }

}
}