Terraform IAC Using Jenkins CI/CD

Below is a complete end-to-end setup for AWS Ubuntu Linux where:

Jenkins is installed on Ubuntu EC2

Terraform is installed via Jenkins pipeline

Terraform HCL code is stored in GitHub

Pipeline runs terraform init, validate, plan, apply, destroy

Uses AWS credentials securely

Step 1: AWS EC2 Prerequisites

Launch EC2:

AMI: Ubuntu 22.04

Instance type: t3.micro (recommended)

Security Group:

TCP 22 → Your IP

TCP 8080 → Your IP (Jenkins)

IAM Role (Recommended):

Attach role with required Terraform permissions (avoid access keys if possible)

Step 2: Install Jenkins on Ubuntu

Commands:

sudo apt update
sudo apt install -y openjdk-17-jre

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt update
sudo apt install -y jenkins

sudo systemctl enable jenkins
sudo systemctl start jenkins


URL: http://<Public_IP>:8080

Step 3: Configure AWS Access (Choose One)

Option A (Best): IAM Role

Attach IAM role to EC2

Terraform automatically authenticates

No keys needed

Option B: Access Key (Not Recommended)

Jenkins → Manage Jenkins → Credentials → Add:

Kind: Secret text

ID: aws-access-key

ID: aws-secret-key

Step 4: GitHub Repo Structure
JenkinsforTerraformIAC/
├── Terraform/
│   ├── main.tf
│   ├── provider.tf
│   ├── variables.tf
│   └── outputs.tf
└── Jenkinsfile

Step 5: Jenkinsfile (Terraform Pipeline with destroy step)
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
                if ! command -v unzip >/dev/null 2>&1; then
                  echo "Installing unzip..."
                  sudo apt-get update -y
                  sudo apt-get install -y unzip
                fi

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

Step 6: Jenkins Permissions Fix (IMPORTANT)

Terraform install requires sudo access:

sudo visudo


Add:

jenkins ALL=(ALL) NOPASSWD: ALL

Step 7: Trigger Pipeline

Create Pipeline job

Select Pipeline script from SCM

Add GitHub repo URL

Save → Build Now
