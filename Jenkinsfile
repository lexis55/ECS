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
    stage('terraform-apply') {
      when { anyOf {branch "prod";branch "dev";branch "test" } }
      steps {
        sh '''
        TARGET_ENV=$BRANCH_NAME
        if [ -d "${TARGET_ENV}/" ]; then
          cd ${TARGET_ENV}
          terraform apply -input=false -auto-approve
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
