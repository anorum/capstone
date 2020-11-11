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
      stage('Lint the Dockerfile') {
          steps {
              sh '''
              hadolint Dockerfile 
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
                #Show the current deployment
                kubectl get deployment

                export BlueVersion=$(kubectl get svc capstone -o=jsonpath='{.spec.selector.version}')
                sed -e 's,BUILD,'${BUILD_NUMBER}',g' < k8s/app.yml | kubectl apply -f -

                # Check the Health of the Deployment

                # If the check fails
                if ! kubectl rollout status deployment capstone-${BUILD_NUMBER}; then
                    # Delete the new deployment
                    kubectl delete deployment capstone-${BUILD_NUMBER}
                    exit 1
                else
                    # If the new deployment succeeded then redirect the LoadBalancer service to the new pod
                    sed -e 's,BUILD,'${BUILD_NUMBER}',g' < k8s/app-service.yml | kubectl apply -f -

                    # Delete the old BlueVersion deployment
                    kubectl delete deployment capstone-$BlueVersion
                fi

                # Show the new deployment
                kubectl get deployment
                '''
            }
        }
    }
}   
}