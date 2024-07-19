#! /bin/bash
yum install -y http://dev.mysql.com/mysql80-community-release-el7-11.noarch.rpm
sed -i 's/gpgcheck=1/gpgcheck=0/g' /etc/yum.repos.d/mysql-community.repo
yum install -y mysql-community-server
systemctl enable --now mysqld
password_match=`awk '/A temporary password is generated for/ {a=$0} END{ print a }' /var/log/mysqld.log | awk '{print $(NF)}'`
echo $password_match
mysql -uroot -p$password_match --connect-expired-password -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'It12345!'; flush privileges; "
password=It12345!
mysql -uroot -p$password -e "grant all privileges on *.* to 'root'@'%' IDENTIFIED BY 'It12345!';  create database foryou; flush privileges;"
mysql -uroot -p$password -e \
" CREATE table foryou.board ( \
   id varchar(10),\
   board_writer varchar(10),\
   board_contents varchar(20),\
   board_Title varchar(20),\
   create_at varchar(20)\
);
INSERT INTO foryou.board (id, board_writer, board_contents, board_Title, create_at) VALUES \
('1', '박지원', 'It12345!', '앤서블 어려워', DATE_FORMAT(NOW(), '%Y-%m-%d %H:%i:%s')),\
('2', '김정림', 'It12345!', '다~그닥~ 다~그닥~', DATE_FORMAT(NOW(), '%Y-%m-%d %H:%i:%s')),\
('3', '최예인', 'It12345!', '테라폼 알고보니...', DATE_FORMAT(NOW(), '%Y-%m-%d %H:%i:%s'));"