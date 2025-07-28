// Jenkinsfile
pipeline {
    agent any
    tools {
        terraform 'Terraform 1.12.2'    
        }
    //environment {
        // AWS Credentials IDs from Jenkins Credentials. Replace with your actual IDs.
       // AWS_ACCESS_KEY_ID_CRED = credentials('your-aws-access-key-id-credential-id') // e.g., 'aws-access-key-id'
       // AWS_SECRET_ACCESS_KEY_CRED = credentials('your-aws-secret-access-key-credential-id') // e.g., 'aws-secret-access-key'

        // SSH Key Credential ID from Jenkins Credentials. Replace with your actual ID.
       // EC2_SSH_KEY_CRED = 'ec2-ssh-key' // ID of your SSH Username with Private Key credential

        // Terraform variables (must match terraform/variables.tf)
        //TF_VAR_aws_region = 'us-east-1' // Change to your preferred region
        //TF_VAR_instance_type = 't2.micro'
        //TF_VAR_ami_id = 'ami-053b0a53597fe097f' // VERIFY THIS FOR YOUR REGION!
        //TF_VAR_key_name = 'your-ec2-key-pair-name' // <--- CHANGE THIS TO YOUR KEY PAIR NAME
    //}

    stages {
        stage('Checkout SCM') {
            steps {
                // Assumes your Jenkins job is configured to pull from a Git repository
                git branch: 'main', url: 'https://github.com/your-repo/ec2-orchestration.git' // <--- CHANGE THIS TO YOUR REPO URL
            }
        }

        stage('Terraform Executions') {
            steps {
                 withAWS(credentials: 'awscreds', region: 'us-east-1') {
                    sh """
                    cd terraform-aws
                    terraform init
                    terraform plan
                    terraform apply -auto-approve   
                    """
                }
            }
        }

    }  
}

/*
        stage('Terraform Plan') {
            steps {
                withCredentials([
                    string(credentialsId: env.AWS_ACCESS_KEY_ID_CRED, variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: env.AWS_SECRET_ACCESS_KEY_CRED, variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    sh """
                    cd terraform
                    terraform plan -out=tfplan.out \
                      -var="aws_region=${TF_VAR_aws_region}" \
                      -var="instance_type=${TF_VAR_instance_type}" \
                      -var="ami_id=${TF_VAR_ami_id}" \
                      -var="key_name=${TF_VAR_key_name}"
                    """
                }
            }
        }

        stage('Terraform Apply & Generate Ansible Inventory') {
            steps {
                script {
                    withCredentials([
                        string(credentialsId: env.AWS_ACCESS_KEY_ID_CRED, variable: 'AWS_ACCESS_KEY_ID'),
                        string(credentialsId: env.AWS_SECRET_ACCESS_KEY_CRED, variable: 'AWS_SECRET_ACCESS_KEY')
                    ]) {
                        sh """
                        cd terraform
                        terraform apply -auto-approve tfplan.out
                        """
                        // Capture the public IP from Terraform output
                        def publicIp = sh(returnStdout: true, script: 'cd terraform && terraform output -raw public_ip').trim()
                        echo "EC2 Instance Public IP: ${publicIp}"

                        // Dynamically create/update Ansible inventory file
                        // The SSH key is injected by sshagent, so its path will be available at ${HOME}/.ssh/id_rsa
                        // Ensure the ansible_user matches the default user for your chosen AMI (e.g., ec2-user for Amazon Linux, ubuntu for Ubuntu)
                        sh """
                        echo '[ec2_instance]' > ansible/inventory.ini
                        echo '${publicIp} ansible_user=ec2-user ansible_ssh_private_key_file=${HOME}/.ssh/id_rsa' >> ansible/inventory.ini
                        echo '' >> ansible/inventory.ini # Add a newline for good measure
                        """
                        echo "Ansible inventory.ini generated successfully."
                    }
                }
            }
        }

        stage('Ansible Verify EC2') {
            steps {
                // Use sshagent to make the private key available to Ansible
                sshagent(credentials: [env.EC2_SSH_KEY_CRED]) {
                    sh """
                    cd ansible
                    # Wait for SSH to be ready on the new instance (important!)
                    # We use a ping command with a retry loop to ensure connectivity
                    ansible-playbook -i inventory.ini --limit ec2_instance --private-key ${HOME}/.ssh/id_rsa -m ping -u ec2-user --connection=ssh --timeout 60 --retries 10 --delay 10 playbook.yml
                    """
                }
            }
        }
    }

    post {
        always {
            // Clean up workspace (optional, but good for Jenkins)
            deleteDir()
        }
        failure {
            echo 'Pipeline failed. Check logs for details.'
            // Optional: Add a stage to destroy infrastructure on failure for testing,
            // but be careful with this in production.
            // stage('Terraform Destroy on Failure') {
            //     steps {
            //         withCredentials([
            //             string(credentialsId: env.AWS_ACCESS_KEY_ID_CRED, variable: 'AWS_ACCESS_KEY_ID'),
            //             string(credentialsId: env.AWS_SECRET_ACCESS_KEY_CRED, variable: 'AWS_SECRET_ACCESS_KEY')
            //         ]) {
            //             sh 'cd terraform && terraform destroy -auto-approve'
            //         }
            //     }
            // }
        }
        success {
            echo 'Pipeline completed successfully!'
            echo 'EC2 instance provisioned and verified by Ansible.'
            echo 'You can find the EC2 Public IP in the "Terraform Apply & Generate Ansible Inventory" stage output.'
        }
    }
}
*/
