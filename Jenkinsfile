pipeline {
  agent any
  stages {
    stage('Unit Test') { 
      steps {
        sh 'sfdx force:apex:test:run'
      }
    }
  }
}
