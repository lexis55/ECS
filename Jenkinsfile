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
        sh '/bin/terraform init'
      }
    }
    stage('terraform-login') {
      steps {
        sh 'export AWS_ACCESS_KEY_ID= '
        sh 'export AWS_SECRET_ACCESS_KEY= '
      }
    }
    stage('terraform-apply') {
      when { anyOf {branch "prod";branch "dev" } }
      steps {
        TARGET_ENV=$BRANCH_NAME
          if [ -d "example-pipelines/environments/${TARGET_ENV}/" ]; then
            cd example-pipelines/environments/${TARGET_ENV}
        sh '/bin/terraform apply -auto-approve -no-color'
      }
    }
  }
  post {
    always {
      cleanWs()
    }
  }
}
