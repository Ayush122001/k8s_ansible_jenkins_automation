#!/usr/bin/bash
export k8s_slave=$(cat /slave | head -n 1)
ip=$k8s_slave
echo $k8s_slave


cat <<EOF | java -jar /root/jenkins-cli.jar -s  http://192.168.43.73:8080/  create-node k8s_slave
<slave>
  <name>k8s_slave</name>
  <description></description>
  <remoteFS>/j</remoteFS>
  <numExecutors>1</numExecutors>
  <mode>NORMAL</mode>
  <retentionStrategy class="hudson.slaves.RetentionStrategy$Always"/>
  <launcher class="hudson.plugins.sshslaves.SSHLauncher" plugin="ssh-slaves@1.31.6">
    <host>${ip}</host>
    <port>22</port>
    <credentialsId>d7a48a3e-f35b-47d5-ba87-f83c672a5163</credentialsId>
    <launchTimeoutSeconds>60</launchTimeoutSeconds>
    <maxNumRetries>10</maxNumRetries>
    <retryWaitTime>15</retryWaitTime>
    <sshHostKeyVerificationStrategy class="hudson.plugins.sshslaves.verifiers.NonVerifyingKeyVerificationStrategy"/>
    <tcpNoDelay>true</tcpNoDelay>
  </launcher>
  <label>k8s_slave</label>
  <nodeProperties/>
</slave>
EOF

java -jar /root/jenkins-cli.jar -s http://192.168.43.73:8080/ -webSocket connect-node k8s_slave
