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
              withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD']]){
					sh '''
						docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
						docker push anorum/udacitycapstone
					'''
          }
      }

}
}
}