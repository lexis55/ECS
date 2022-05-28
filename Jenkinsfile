pipeline {
  agent { label 'linux'}
  options {
    skipDefaultCheckout(true)
  }
  stages{
    stage('clean workspace') {
      steps {
        cleanWs()
      }
    }
    stage('checkout') {
      steps {
        checkout scm
      }
    }
    stage('terraform-init-apply') {
      steps {
        sh '''
          cd dev
          terraform init
          terraform plan
        fi'''
      }
    }
  }
  post {
    always {
      cleanWs()
    }
  }
}
