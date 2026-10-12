pipeline {
    agent any

    parameters {
        choice(
            name: 'ENVIRONMENT',
            choices: ['dev', 'stg', 'prod'],
            description: 'اختر البيئة المراد تنفيذ التغييرات عليها'
        )
    }

    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
    }

    stages {
        stage('Checkout') {
            steps {
                echo '=== Stage 1: Checkout Code ==='
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                echo '=== Stage 2: Terraform Init ==='
                sh 'terraform init'
            }
        }

        stage('Workspace Select') {
            steps {
                echo "=== Stage 3: Selecting Workspace: ${params.ENVIRONMENT} ==="
                sh """
                    terraform workspace select ${params.ENVIRONMENT} || terraform workspace new ${params.ENVIRONMENT}
                """
            }
        }

        stage('Plan') {
            steps {
                echo '=== Stage 4: Terraform Plan ==='
                sh "terraform plan -var-file=${params.ENVIRONMENT}.tfvars"
            }
        }

        stage('Approval') {
            steps {
                script {
                    echo '=== Waiting for Manual Approval ==='
                    input message: "هل ترغب في تطبيق التغييرات على بيئة (${params.ENVIRONMENT})؟", ok: 'Approve'
                }
            }
        }

        stage('Apply') {
            steps {
                echo '=== Stage 5: Terraform Apply ==='
                sh "terraform apply -var-file=${params.ENVIRONMENT}.tfvars -auto-approve"
            }
        }
    }

    post {
        success {
            echo 'Pipeline Executed Successfully!'
        }
        failure {
            echo 'Pipeline Failed!'
        }
    }
}
