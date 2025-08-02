// Jenkinsfile
pipeline {

    agent any

    tools {
        terraform 'Terraform 1.12.0'    
        }
   

    stages {
        stage('Checkout SCM') {
            steps {
                // Assumes your Jenkins job is configured to pull from a Git repository
                git branch: 'main', url: 'git@github.com:sayanti-mondal/devops_portfolio_projects.git' // <--- CHANGE THIS TO YOUR REPO URL
            }
        }

        stage('Terraform Executions') {
            steps {
                script {
                  withAWS(credentials: 'awscreds', region: 'us-east-1') {
                    sh """
                    cd terraform-aws
                    terraform init
                    terraform plan
                    terraform apply -auto-approve  
                    """
                    def publicIp = sh(returnStdout: true, script: 'cd terraform-aws && terraform output -raw public_ip').trim()
                
                    echo "EC2 Instance Public IP: ${publicIp}" // Verify the IP is captured
                     // Capture the public IP from Terraform output
                    //def publicIp = terraform output -raw public_ip

                    // Ensure the target directory exists
                    //sh "mkdir -p Project4/ansible" 


                    sh """
                    # echo '[ansible_target]' > exercise5/inventory.ini
                    # echo '${publicIp} ansible_user=ubuntu ansible_ssh_private_key_file=${HOME}/.ssh/id_rsa' >> ansible/inventory.ini
                    # echo '' >> ansible/inventory.ini # Add a newline for good measure

                    echo '[webservers]' > inventory.ini
                    echo '${publicIp} 
                    # ansible_user=ubuntu ansible_ssh_private_key_file=${HOME}/.ssh/id_rsa' >> inventory.ini
                    echo '' >> inventory.ini # Add a newline for good measure   
                    
                    echo "Ansible inventory.ini generated successfully." 

                    """
                    // Move the inventory file to its final destination.
                        sh """
                        mv inventory.ini exercise5/
                        echo 'Ansible inventory.ini moved to exercise5/'
                        """

                   
                }
            }

        }
     }





        stage('Ansible Verify EC2') {
            steps {
                // Use sshagent to make the private key available to Ansible
                withAWS(credentials: 'awscreds', region: 'us-east-1') {
                    // sh """
                    // cd exercise5
                    // # Wait for SSH to be ready on the new instance (important!)
                    // # We use a ping command with a retry loop to ensure connectivity
                    // #ansible -i inventory.ini --limit ec2_instance --private-key ${HOME}/.ssh/id_rsa -m ping -u ec2-user --connection=ssh --timeout 60 --retries 10 --delay 10 playbook.yml
                    // ansible -i inventory.ini -m ping ansible_target
                    // """

                    dir('exercise5/') {  
                      ansiblePlaybook credentialsId: 'jenkins_ansible_ec2', 
                                      disableHostKeyChecking: true, 
                                      installation: 'ansible', 
                                      inventory: 'inventory.ini', 
                                      playbook: 'web.yml' 
                                
                    }
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
