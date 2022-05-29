pipeline {
  agent { label 'linux'}
  options {
    skipDefaultCheckout(true)
    ansiColor('xterm')
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
        sh '/bin/terraform apply -auto-approve
      }
    }
  }
  post {
    always {
      cleanWs()
    }
  }
}
