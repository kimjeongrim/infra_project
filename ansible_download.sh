# key file 생성
if [ ! -f ~/.ssh/id_rsa ]; then   ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -q -N ""; fi

# 생략 가능
sed "s/StrictModes yes/#StrictModes yes" /etc/ssh/sshd_config
sed "s/PassWordAuthentication no/#PassWordAuthentication no" /etc/ssh/sshd_config

# ip 수정 필요
scp -o StrictHostKeyChecking=no .ssh/id_rsa.pub ec2-user@10.0.0.12:/root/.ssh/authorized_keys
scp -o StrictHostKeyChecking=no .ssh/id_rsa.pub ec2-user@10.0.1.11:/root/.ssh/authorized_keys
scp -o StrictHostKeyChecking=no .ssh/id_rsa.pub ec2-user@10.0.1.12:/root/.ssh/authorized_keys

sudo su - 

yum install -y epel-release

yum install -y ansible

# ip 수정 필요
cat >> /etc/ansible/hosts << EOF
[all]
10.0.0.12
10.0.1.11
10.0.1.12
EOF

# ip 수정 필요
cat > /etc/hosts << EOF
10.0.0.11 master ma ma.ogurim.store
10.0.0.12 node1 no1 no1.ogurim.store
10.0.1.11 node2 no2 no2.ogurim.store
10.0.1.12 node3 no3 no3.ogurim.store
EOF

# ip 수정 필요
scp -o StrictHostKeyChecking=no /etc/hosts ec2-user@10.0.0.12:/etc/hosts
scp -o StrictHostKeyChecking=no /etc/hosts ec2-user@10.0.1.11:/etc/hosts
scp -o StrictHostKeyChecking=no /etc/hosts ec2-user@10.0.1.12:/etc/hosts