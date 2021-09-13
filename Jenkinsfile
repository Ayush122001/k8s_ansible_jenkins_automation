pipeline{
    agent none
    stages{
        stage("Provisioning Nodes, configuring them "){
            agent{
                label "ansible"
            }
            steps{
            sh 'cd /root/ws/k8s_cluster_with_ansible/ '
            sh 'export AWS_ACCESS_KEY_ID=""; export AWS_SECRET_ACCESS_KEY="";export export AWS_REGION="";ansible-playbook /root/ws/k8s_cluster_with_ansible/k8s_cluster.yml'
            sh 'scp /root/master 192.168.43.73:/master'
            sh 'scp /root/slave 192.168.43.73:/slave'
            }
        }
        stage("Configure as jenkins slave "){
            agent{
                label 'master'
            }
            steps{
                sh 'sudo bash /root/master.sh'
                sh 'sudo bash /root/slave.sh'
                sh 'sleep 30'
            }
        }
        stage('Generating token from master'){
            agent{
                label 'k8s_master'
            }
            steps{
                sh 'sudo kubeadm token create --print-join-command > token'
                stash includes: 'token', name: "token"
            }
        }
        stage('Joining slave to master'){
            agent{
                label 'k8s_slave'
            }
            steps{
                unstash "token"
                sh 'sudo cat token | sudo bash'
            }
        }
    }
}
