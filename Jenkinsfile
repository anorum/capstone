pipeline {
  agent any
  stages {

      stage('The cluster was created. So update the context on the Jenkins Server') {
          steps {
              withAWS(region:'us-west-2', credentials:'aws_access_id') {
              sh '''
              aws eks --region us-west-2 update-kubeconfig --name udacitycapstone
              '''
              }
          }
      }
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
              docker build -t anorum/udacitycapstone:${BUILD_NUMBER} .
              '''
          }
      }
      stage('Publish the Docker Image') {
          steps {
              withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD']]){
					sh '''
						docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
						docker push anorum/udacitycapstone:${BUILD_NUMBER}
					'''
            }
        }
    }
    stage('Deploy Green Version and delete Blue Version') {
        steps {
            withAWS(region:'us-west-2', credentials:'aws_access_id') {
                sh '''
                export BlueVersion=$(kubectl get svc capstone -o=jsonpath='{.spec.selector.version}')
                sed -e 's,BUILD,'${BUILD_NUMBER}',g' < k8s/app.yml | kubectl apply -f -

                # Check the Health of the Deployment

                if ! kubectl rollout status deployment capstone-${BUILD_NUMBER}; then
                    kubectl delete deployment capstone-${BUILD_NUMBER}
                    kubectl rollout status deployment capstone-${BUILD_NUMBER}
                    exit 1
                else
                    sed -e 's,BUILD,'${BUILD_NUMBER}',g' < k8s/app-service.yml | kubectl apply -f -
                    kubectl delete deployment capstone-$BlueVersion
                fi      
                '''
            }
        }
    }
}   
}