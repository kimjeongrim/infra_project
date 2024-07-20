#!/bin/bash
echo 'starting ansible playbooks...'

# 초기 설정
sleep 60
sudo systemctl stop apparmor
sudo systemctl disable apparmor
sudo apt-get install -y tree

# Ansible 설정 파일에 추가
sudo sh -c 'echo "[defaults]
inventory = /home/ubuntu/ansible/inventory
host_key_checking = False
[ssh_connection]
ssh_args = -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ProxyCommand=\"ssh -W %h:%p -q ubuntu@10.0.0.11\"
" > /etc/ansible/ansible.cfg'

# SSH 키 파일 권한 설정
chmod 600 /home/ubuntu/ansible/foryou_key.pem

# 마스터 노드 플레이북 실행
ssh -o StrictHostKeyChecking=no -i /home/ubuntu/.ssh/id_rsa ubuntu@10.0.0.11 "ansible-playbook -i /home/ubuntu/ansible/inventory /home/ubuntu/ansible/setting.yml -vvv | tee /home/ubuntu/ansible/setting.log"
sleep 60
ssh -o StrictHostKeyChecking=no -i /home/ubuntu/.ssh/id_rsa ubuntu@10.0.0.11 "ansible-playbook -i /home/ubuntu/ansible/inventory /home/ubuntu/ansible/k8s.yml -vvv | tee /home/ubuntu/ansible/k8s.log"
sleep 60
mkdir /home/ubuntu/ansible/galaxy
ansible-galaxy init nginx
mv nginx /home/ubuntu/ansible/galaxy/nginx/
ansible-galaxy init tomcat
mv tomcat /home/ubuntu/ansible/galaxy/tomcat/
cp -r  /home/ubuntu/ansible/role/nginx/* /home/ubuntu/ansible/galaxy/nginx/
cp -r  /home/ubuntu/ansible/role/tomcat/* /home/ubuntu/ansible/galaxy/tomcat/
sleep 60
ssh -o StrictHostKeyChecking=no -i /home/ubuntu/.ssh/id_rsa ubuntu@10.0.0.11 "ansible-playbook -i /home/ubuntu/ansible/inventory /home/ubuntu/ansible/nginx.yml -vvv | tee /home/ubuntu/ansible/nginx.log"
sleep 60
ssh -o StrictHostKeyChecking=no -i /home/ubuntu/.ssh/id_rsa ubuntu@10.0.0.11 "ansible-playbook -i /home/ubuntu/ansible/inventory /home/ubuntu/ansible/tomcat.yml -vvv | tee /home/ubuntu/ansible/tomcat.log"
sleep 60
ssh -o StrictHostKeyChecking=no -i /home/ubuntu/.ssh/id_rsa ubuntu@10.0.0.11 "ansible-playbook -i /home/ubuntu/ansible/inventory /home/ubuntu/ansible/helm_prometheus.yml -vvv | tee /home/ubuntu/ansible/helm_prometheus.log"