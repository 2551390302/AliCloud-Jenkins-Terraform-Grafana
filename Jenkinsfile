pipeline {
    agent any

    parameters {
        choice(
            name: 'ENVIRONMENT',
            choices: ['dev', 'stage', 'prod'],
            description: '选择要部署的环境'
        )
    }

    environment {
        // 使用 Jenkins 标准凭据管理
        ALICLOUD_CREDS = credentials('Ali-Cloud-credentials')
        ALICLOUD_REGION = 'cn-chengdu'
        
        // Terraform OSS Backend 需要的环境变量（用于 state file 访问）
        ALICLOUD_ACCESS_KEY = "${ALICLOUD_CREDS_USR}"
        ALICLOUD_SECRET_KEY = "${ALICLOUD_CREDS_PSW}"
        
        // Terraform provider 需要的变量（用于资源创建）
        TF_VAR_alicloud_access_key = "${ALICLOUD_CREDS_USR}"
        TF_VAR_alicloud_secret_key = "${ALICLOUD_CREDS_PSW}"
        TF_VAR_alicloud_region = "${ALICLOUD_REGION}"

        FEISHU_WEBHOOK = credentials('feishu-webhook-url')
        TF_VAR_feishu_webhook_url = "${FEISHU_WEBHOOK}"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'feature/init',
                    url: 'https://github.com/2551390302/AliCloud-Jenkins-Terraform-Grafana.git',
                    credentialsId: 'github-devops-terraform'
            }
        }

        stage('Clean Terraform Cache') {
            steps {
                script {
                    echo "Cleaning Terraform cache to ensure fresh initialization..."
                    dir("Terraform/environments/${params.ENVIRONMENT}") {
                        sh '''
                            echo "Removing .terraform directory..."
                            rm -rf .terraform
                            echo "Removing .terraform.lock.hcl..."
                            rm -f .terraform.lock.hcl
                            echo "Checking for lock file..."
                            if [ -f .terraform.lock.hcl ]; then
                                echo "ERROR: Lock file still exists!"
                                exit 1
                            else
                                echo "Lock file removed successfully!"
                            fi
                            echo "Cache cleaned successfully!"
                        '''
                    }
                }
            }
        }

        stage('Test Alicloud Credentials') {
            steps {
                script {
                    echo "Testing Alicloud Credentials..."
                    sh 'echo "Access Key ID is set: ${ALICLOUD_CREDS_USR:+yes}"'
                    sh 'echo "Region: ${ALICLOUD_REGION:-not set}"'
                }
            }
        }

        stage('switch to relevant env folder') {
            steps {
                script {
                    dir("Terraform/environments/${params.ENVIRONMENT}") {
                        // 后续 stage 会在此目录下执行
                        // 但 dir 的作用域有限，所以需要在每个 stage 中重新进入
                        // 我们可以在每个 Terraform stage 中显式使用 dir
                    }
                }
            }
        }

        stage('Terraform Init') {
            steps {
                dir("Terraform/environments/${params.ENVIRONMENT}") {
                    script {
                        echo "Initializing Terraform..."
                        sh 'terraform init -input=false'
                    }
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir("Terraform/environments/${params.ENVIRONMENT}") {
                    sh 'terraform fmt -check'
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir("Terraform/environments/${params.ENVIRONMENT}") {
                    sh 'terraform plan -out=tfplan'
                }
            }
            post {
                success {
                    archiveArtifacts artifacts: "Terraform/environments/${params.ENVIRONMENT}/tfplan"
                }
            }
        }

        stage('Approval') {
            when {
                expression { params.ENVIRONMENT == 'prod' }
            }
            steps {
                input message: "是否批准将计划应用到生产环境？请确认变更。", ok: '批准'
            }
        }

        stage('Clean Helm Pending') {
            steps {
                script {
                    dir("Terraform/environments/${params.ENVIRONMENT}") {
                        sh '''
                            if helm ls -n nsp-d-devops01-monitoring | grep prometheus | grep -E 'pending|failed'; then
                                echo "Found pending/failed release, trying to rollback..."
                                helm rollback prometheus 1 -n nsp-d-devops01-monitoring || true
                            fi
                        '''
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir("Terraform/environments/${params.ENVIRONMENT}") {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
            post {
                success {
                    script {
                        dir("Terraform/environments/${params.ENVIRONMENT}") {
                            sh 'terraform output -raw kubeconfig > kubeconfig || true'
                        }
                        stash name: 'kubeconfig', includes: "Terraform/environments/${params.ENVIRONMENT}/kubeconfig", allowEmpty: true
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                try {
                    cleanWs()
                } catch (Exception e) {
                    echo "cleanWs failed: ${e.message}"
                }
            }
        }
        success {
            echo "环境 ${params.ENVIRONMENT} 基础设施变更成功！"
        }
        failure {
            echo "环境 ${params.ENVIRONMENT} 基础设施变更失败，请检查日志。"
        }
    }
}