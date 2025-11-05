pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                echo "Checking out repository..."
                checkout scm
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
