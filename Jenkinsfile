pipeline {
  agent {
    node {
      label 'BuildNode'
    }

  }
  stages {
    stage('PULL') {
      steps {
        git(credentialsId: 'to-haibe-online-backend-repo', branch: 'test', url: '[SSH GIT]')
      }
    }

    stage('SAST') {
      parallel {
        stage('PREPARE') {
          steps {
            sh 'cp -ar /home/$USER/ENVS/"${DEPLOY_ON}"/certs  $PWD/src/notification/'
          }
        }

        stage('nodejsscan') {
          steps {
            sh 'njsscan . --output /home/$USER/reports/nodejsscan-report'
          }
        }

        stage('snyk') {
          steps {
            sh 'echo "SAST Snyk"'
          }
        }

        stage('npm audit') {
          steps {
            sh 'echo "SAST npm audit"'
          }
        }

      }
    }

    stage('BUILD') {
      steps {
        sh 'sudo docker stop "${DEPLOY_ON}"_lts || true'
        sh 'sudo docker rm "${DEPLOY_ON}"_lts || true'
        sh 'sudo docker build -t ${DEPLOY_ON}:lts .'
      }
    }

    stage('DEPLOY') {
      steps {
        sh 'sudo docker run --rm --env-file /home/$USER/ENVS/"${DEPLOY_ON}"/"${DEPLOY_ON}" --name "${DEPLOY_ON}"_lts  -d -p "${DEPLOY_PORT}":3000 "${DEPLOY_ON}":lts'
        sh 'sudo docker container prune -f'
        sh 'sudo docker rmi $(sudo docker images --filter "dangling=true" -q --no-trunc)'
      }
    }

    stage('DAST') {
      steps {
        sh 'sudo docker run --rm owasp/zap2docker-stable zap-baseline.py -t http://[DNS]:"${DEPLOY_PORT}"  || true'
      }
    }

  }
  environment {
    DEPLOY_ON = 'test'
    DEPLOY_PORT = '9000'
  }
}