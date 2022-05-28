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
    stage('terraform-init') {
      steps {
        sh '''
          cd dev
          terraform init
        fi'''
      }
    }
    stage('terraform-apply') {
      steps {
        sh '''
          cd dev
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
