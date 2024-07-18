tast server

sudo su - 
yum install -y nginx
# ip 수정 필요
scp /etc/nginx/nginx.conf ec2-user@10.0.0.11:/root

---

master server

sudo su - 
yum install -y tree
mkdir galaxy
cd galaxy/
ansible-galaxy init nginx
mv /root/nginx.conf /root/galaxy/nginx/templates/nginx.j2

cat > /root/galaxy/nginx/files/index.html << EOF
<html>
<body>
<h1>FORYOU-ANSIBLE-NGINX-TEST</h1>
</body>
</html>
EOF
# ip 수정 필요
cat > /root/galaxy/nginx/tests/inventory << EOF
10.0.0.12
10.0.1.11
10.0.1.12
EOF

echo "#" > /root/galaxy/nginx/tests/test.yml

echo "package: nginx" >> /root/galaxy/nginx/vars/main.yml

cat >> /root/galaxy/nginx/tasks/main.yml << EOF
- name: "install {{ package }}"
  yum:
    name: "{{ package }}"
    state: present
  notify:
    - started nginx

- name: index.html copy
  copy:
    src: index.html
    dest: /usr/share/nginx/html
    owner: nginx
    group: nginx
  notify: firewall open nginx

- name: template copy
  template:
    src: nginx.j2
    dest: /etc/nginx/nginx.conf
    owner: nginx
    group: nginx
  notify: restarted nginx
EOF

sed -i -r -e "/root/a\index index.html;" /root/galaxy/nginx/templates/nginx.j2

cat >> /root/galaxy/nginx/handlers/main.yml << EOF
- name: "started {{ package }}"
  systemd:
    name: "{{ package }}"
    state: started

- name: "restarted {{ package }}"
  systemd:
    name: "{{ package }}"
    state: restarted

- name: "firewall open {{ package }}"
  firewalld:
    port: 80/tcp
    state: enabled 
EOF

cat > nginx.yml << EOF
---
- name: install galaxy nginx
  hosts: all
  roles:
      - nginx
EOF

ansible-playbook nginx.yml

#원격서버에 system autoremove nginx 실행시키고 다시 ansible playbook 실행