def getBuildUser() {
    return currentBuild.rawBuild.getCause(Cause.UserIdCause).getUserId()
}
pipeline {
  agent any
  stages {
    stage('Authorize sandbox access') { 
      steps {
        echo 'Authorizing..'
        sh 'sfdx force:auth:jwt:grant --clientid 3MVG9KlmwBKoC7U2wyLeOyzUXsAgoWTQoNccKnLdTh5qFw1Nzuv71i5H96EWLAiDLH.3t6G8E_uOp458I_aOt --jwtkeyfile /opt/bcaexpertise/data/jenkins/.ssh/server.key --username interface.ci@bca.com.integ --instanceurl https://test.salesforce.com --setdefaultdevhubusername'
      }
    }
    stage('Run Unit Test') { 
      steps {
        echo 'Testing...'
        sh 'sfdx force:apex:test:run -u interface.ci@bca.com.integ'
      }
    }
    stage('Deploy with unit test') { 
      steps {
        echo 'Deploying..'
        sh 'pwd > workspace'
        //sh 'sfdx force:source:deploy -c -p force-app -u interface.ci@bca.com.integ --testlevel RunLocalTests'
        //sh 'sfdx force:org:create -s -f config/project-scratch-def.json -a stoubalhouse-org'
        sh 'sfdx force:org:create --definitionfile config/project-scratch-def.json --setalias ciorg --wait 10 --durationdays 1'
        sh 'sfdx force:source:push'
      }
    }
  }
}

