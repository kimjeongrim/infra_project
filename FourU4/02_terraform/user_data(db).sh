#! /bin/bash

# SSH 설정
echo "PubkeyAcceptedKeyTypes=+ssh-rsa" | sudo tee -a /etc/ssh/sshd_config.d/10-insecure-rsa-keysig.conf
sudo systemctl reload sshd

echo "${tls_private_key.ssh.private_key_pem}" | sudo tee /home/ubuntu/.ssh/id_rsa
sudo chown ubuntu /home/ubuntu/.ssh/id_rsa
sudo chgrp ubuntu /home/ubuntu/.ssh/id_rsa
sudo chmod 600 /home/ubuntu/.ssh/id_rsa

# MySQL 설치
sudo dnf install -y https://dev.mysql.com/get/mysql80-community-release-el9-1.noarch.rpm 
sudo sed -i 's/gpgcheck=1/gpgcheck=0/g' /etc/yum.repos.d/mysql-community.repo
sudo dnf install -y mysql-server
sudo systemctl enable --now mysqld

# MySQL 초기 설정
password_match=$(sudo grep 'A temporary password is generated for' /var/log/mysqld.log | awk '{print $NF}')
echo "Temporary MySQL root password: $password_match"

mysql -uroot -p"$password_match" --connect-expired-password -e \
"ALTER USER 'root'@'localhost' IDENTIFIED BY 'It12345!'; flush privileges;"
password="It12345!"
mysql -uroot -p"$password" -e "grant all privileges on *.* to 'root'@'%' IDENTIFIED BY 'It12345!'; create database foryou; flush privileges;"
mysql -uroot -p"$password" -e \
" CREATE table foryou.board ( \
   id varchar(10),\
   board_writer varchar(10),\
   board_contents varchar(20),\
   board_Title varchar(20),\
   create_at varchar(20)\
);"

mysql -uroot -p"$password" -e \
"INSERT INTO foryou.board (id, board_writer, board_contents, board_Title, create_at) VALUES \
('1', '박지원',  '앤서블 어려워', ,'4조 최고', DATE_FORMAT(NOW(), '%Y-%m-%d %H:%i:%s')),\
('2', '김정림', '다~그닥~ 다~그닥~', '말이 옷이 다 맘에 안들면?', DATE_FORMAT(NOW(), '%Y-%m-%d %H:%i:%s')),\
('3', '최예인', '테라폼 알고보니...', '다람이', DATE_FORMAT(NOW(), '%Y-%m-%d %H:%i:%s'));"