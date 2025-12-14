pipeline {
    agent any

    environment {
        TERRAFORM_VERSION = "1.6.6"
        TF_DIR = "Terraform"
        AWS_DEFAULT_REGION = "eu-north-1"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/Light-zzz/JenkinsforTerraformIAC.git'
            }
        }

        stage('Install Terraform') {
            steps {
                sh '''
                # Install unzip if missing
                if ! command -v unzip >/dev/null 2>&1; then
                  echo "Installing unzip..."
                  sudo apt-get update -y
                  sudo apt-get install -y unzip
                fi
        
                # Install terraform if missing
                if ! command -v terraform >/dev/null 2>&1; then
                  echo "Installing Terraform..."
                  curl -O https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
                  unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
                  sudo mv terraform /usr/local/bin/
                fi
        
                terraform -version
                '''
            }
        }

        stage('Terraform Init') {
            steps {
                dir("${TF_DIR}") {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir("${TF_DIR}") {
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir("${TF_DIR}") {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir("${TF_DIR}") {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
        stage('Terraform Destroy') {
            steps {
                dir("${TF_DIR}") {
                    sh 'terraform destroy -auto-approve'
                }
            }
        }
    }

    post {
        success {
            echo 'Terraform deployment and Destroy successful'
        }
        failure {
            echo 'Terraform deployment failed'
        }
    }
}
