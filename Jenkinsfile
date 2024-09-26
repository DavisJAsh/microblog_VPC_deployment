pipeline {
  agent any
    stages {
        stages {
        stage ('Build') {
            steps {
                sh '''#!/bin/bash
                python3.9 -m venv venv
		source venv/bin/activate
		pip install --upgrade pip
		pip install -r requirements.txt
		pip install gunicorn pymysql cryptography
		export FLASK_APP=microblog.py
		flask translate compile
		flask db upgrade
                '''
            }
        }
        stage ('Test') {
            steps {
                sh '''#!/bin/bash
                source venv/bin/activate
                py.test ./tests/unit/ --verbose --junit-xml test-reports/results.xml
                '''
            }
            post {
                always {
                    junit 'test-reports/results.xml'
                }
            }
        }
      stage ('OWASP FS SCAN') {
            steps {
                dependencyCheck additionalArguments: '--scan ./ --disableYarnAudit --disableNodeAudit', odcInstallation: 'DP-Check'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
      stage ('Clean') {
            steps {
                sh '''#!/bin/bash
                if [[ $(ps aux | grep -i "gunicorn" | tr -s " " | head -n 1 | cut -d " " -f 2) != 0 ]]
                then
                ps aux | grep -i "gunicorn" | tr -s " " | head -n 1 | cut -d " " -f 2 > pid.txt
                kill $(cat pid.txt)
                exit 0
                fi
                '''
            }
        }
      stage ('Deploy') {
            steps {
                sh '''#!/bin/bash
		
		#Setting variables for the SSH command
		SSH_Key="/var/lib/jenkins/.ssh/id_ed25519"
		file_path="/home/ubuntu/microblog_VPC_deployment/scripts/setup.sh"
		login_name="ubuntu"
		script_url="https://raw.githubusercontent.com/DavisJAsh/microblog_VPC_deployment/refs/heads/main/scripts/setup.sh"	
 		
		#Downloading the setup script
		ssh -i "$SSH_Key" "$login_name@$Web_Server" "curl -L -o $file_path $script_url 2>/dev/null && chmod 755 $file_path && source $file_path $Application_Server"
		'''
            }
        }
    }
}
