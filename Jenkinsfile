pipeline {
  agent { label 'linux'}
  options {
    skipDefaultCheckout(true)
    ansiColor('xterm')
  }
  environment {
        AWS_ACCESS_KEY_ID     = credentials('jenkins-aws-secret-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('jenkins-aws-secret-access-key')
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
        sh '/bin/terraform init'
      }
    }
    stage('terraform-apply') {
      steps {
        sh '/bin/terraform apply -auto-approve'
      }
    }
  }
  post {
    always {
      cleanWs()
    }
  }
}
