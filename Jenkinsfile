pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
        TF_VERSION = "1.6.6"
    }

    stages {

        stage('Install Terraform') {
            steps {
                sh '''
                if ! terraform -v; then
                  sudo yum install -y unzip wget
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
                sh 'terraform init'
            }
        }

        stage('Terraform Validate') {
            steps {
                sh 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan'
            }
        }

        stage('Terraform Apply') {
            steps {
                input message: "Approve Terraform Apply?"
                sh 'terraform apply -auto-approve'
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
