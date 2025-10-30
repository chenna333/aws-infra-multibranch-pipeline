pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
        TF_VERSION = '1.9.5'
        BACKEND_BUCKET = 'multiinfrs-unique-bucket'  // Update with your S3 bucket
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Checking out repository..."
                checkout scm
            }
        }

        stage('Setup Terraform') {
            steps {
                echo "Installing Terraform if not available..."
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

        stage('Terraform Init') {
            steps {
                script {
                    def envName = env.BRANCH_NAME.trim()
                    echo "Initializing Terraform backend for ${envName}..."

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

        stage('Terraform Validate') {
            steps {
                echo "Validating Terraform configuration..."
                sh 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    def envName = env.BRANCH_NAME.trim()
                    echo "Running Terraform plan for ${envName}..."
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
                    echo "Applying Terraform configuration for ${envName}..."
                    sh "terraform apply -auto-approve tfplan-${envName}"
                }
            }
        }

        stage('EKS Cluster Access and Namespace Setup') {
            when {
                branch pattern: ".*", comparator: "REGEXP"
            }
            steps {
                script {
                    def envName = env.BRANCH_NAME.trim()
                    echo "Setting up kubectl access for ${envName} cluster..."

                    // Update kubeconfig for respective cluster
                    sh """
                        aws eks update-kubeconfig --name ${envName}-eks-cluster --region ${AWS_DEFAULT_REGION}
                        kubectl config current-context
                    """

                    echo "Creating namespace and roles for ${envName}..."
                    sh """
                        kubectl apply -f k8s/namespace.yaml
                        kubectl apply -f k8s/roles.yaml
                    """
                }
            }
        }
    }

    post {
        always {
            echo "Cleaning up workspace..."
            deleteDir()
        }
        success {
            echo "✅ Terraform and EKS deployment completed successfully."
        }
        failure {
            echo "❌ Pipeline failed."
        }
    }
}
