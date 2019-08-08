pipeline {
  agent any
  stages {
    stage('Authorize sandbox access') { 
      steps {
        echo 'Authorizing..'
        sh 'sfdx force:auth:jwt:grant --clientid 3MVG9ZPHiJTk7yFz1xusewVMyUEyjAwXD5.IllPw9T7Y3K4grd16m_jiQ2Ca0HKCErFsqEP1Sh7IE_CrMuunH --jwtkeyfile /Users/stoubal/desktop/server/server.key --username stoubal@salesforce.com.dev --instanceurl https://test.salesforce.com --setdefaultdevhubusername'
      }
    }
    stage('Unit Test') { 
      steps {
        echo 'Testing..'
        echo "Running ${env.BUILD_ID} on ${env.JENKINS_URL}"
        sh 'sfdx force:apex:test:run -u stoubal@salesforce.com.dev > resultTest'
        def resulttest = sh 'cat resultTest'
        println resulttest
      }
    }
  }
}