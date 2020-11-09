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
  }

//    stage('create eks cluster') {
//        steps {
//            withAWS(region: 'us-west-2', crednetials: 'aws_acces_id') {
//                sh '''
//                eksctl create
//                '''
//            }
//        }
//    },

//    stage('create kube config file') {
//        steps {
//            withAWS(region: 'us-west-2', credentials: 'aws_access_id') {
//                sh '''
//                 aws eks --region us-west-2 update-kubeconfig --name udacitycapstone
//                '''
//            }
//        }
//    }

}