pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
        TF_VERSION = '1.9.5'
        BACKEND_BUCKET = 'multiinfrs-unique-bucket'  // your existing bucket
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Checking out code..."
                checkout scm
            }
        }

        stage('Setup Terraform') {
            steps {
                echo "Setting up Terraform..."
                sh '''
                    if ! command -v terraform >/dev/null 2>&1; then
                        curl -o terraform.zip https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip
                        unzip terraform.zip
                        sudo mv terraform /usr/local/bin/
                    fi
                    terraform version
                '''
            }
        }

        stage('Initialize Backend') {
            steps {
                script {
                    // Detect environment from branch name
                    def envName = env.BRANCH_NAME.trim()
                    echo "Detected environment: ${envName}"

                    sh """
                    terraform init \
                      -reconfigure \
                      -backend-config="bucket=${BACKEND_BUCKET}" \
                      -backend-config="key=${envName}/terraform.tfstate" \
                      -backend-config="region=${AWS_DEFAULT_REGION}"
                    """
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    def envName = env.BRANCH_NAME.trim()
                    echo "Running terraform plan for ${envName}"
                    sh "terraform plan -var-file=${envName}/terraform.tfvars -out=tfplan-${envName}"
                }
            }
        }

        stage('Terraform Apply') {
            when {
                branch pattern: ".*", comparator: "REGEXP"
            }
            steps {
                script {
                    def envName = env.BRANCH_NAME.trim()
                    echo "Applying Terraform changes for ${envName}"
                    sh "terraform apply -auto-approve tfplan-${envName}"
                }
            }
        }
    }

    post {
        always {
            echo "Cleaning workspace..."
            deleteDir()
        }
        success {
            echo "Terraform deployment completed successfully ✅"
        }
        failure {
            echo "Terraform deployment failed ❌"
        }
    }
}

