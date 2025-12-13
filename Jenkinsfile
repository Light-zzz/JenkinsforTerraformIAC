pipeline {
    agent any

    environment {
        TF_VERSION = "1.6.6"
        AWS_CREDS  = credentials('aws_creds')
    }

    stages {

        stage('Install Terraform') {
            steps {
                sh '''
                export AWS_ACCESS_KEY_ID=$AWS_CREDS_USR
                export AWS_SECRET_ACCESS_KEY=$AWS_CREDS_PSW

                if ! command -v terraform >/dev/null 2>&1; then
                  sudo yum install -y wget unzip
                  wget https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip
                  unzip terraform_${TF_VERSION}_linux_amd64.zip
                  sudo mv terraform /usr/local/bin/
                fi

                terraform -v
                '''
            }
        }

        stage('Terraform Init') {
            steps {
                sh '''
                export AWS_ACCESS_KEY_ID=$AWS_CREDS_USR
                export AWS_SECRET_ACCESS_KEY=$AWS_CREDS_PSW
                terraform init
                '''
            }
        }

        stage('Terraform Validate') {
            steps {
                sh 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh '''
                export AWS_ACCESS_KEY_ID=$AWS_CREDS_USR
                export AWS_SECRET_ACCESS_KEY=$AWS_CREDS_PSW
                terraform plan
                '''
            }
        }

        stage('Terraform Apply') {
            steps {
                input message: "Approve Terraform Apply?"
                sh '''
                export AWS_ACCESS_KEY_ID=$AWS_CREDS_USR
                export AWS_SECRET_ACCESS_KEY=$AWS_CREDS_PSW
                terraform apply -auto-approve
                '''
            }
        }
    }

    post {
        success {
            echo "Terraform Infrastructure Created Successfully"
        }
        failure {
            echo "Terraform Pipeline Failed"
        }
    }
}
