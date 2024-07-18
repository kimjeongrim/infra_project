# ansible-galaxy

mkdir ~/galaxy
cd galaxy/
ansible-galaxy init tomcat

# package: tomcat
cat > /root/galaxy/tomcat/vars/main.yml << EOF
package: tomcat
EOF

# 설치할 서버 명시하기
cat > /root/galaxy/tomcat/tests/inventory << EOF
10.0.0.36
EOF

# 주석 처리
echo "#" >/root/galaxy/tomcat/tests/test.yml

# 설치 및 파일 copy
cat > /root/galaxy/tomcat/tasks/main.yml << EOF
- name: install jdk, tar
  yum:
    name:
      - java-11-openjdk
      - tar
    state: present

- name: "download {{ package }}"
  get_url:
    url: "https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.71/bin/apache-tomcat-9.0.71.tar.gz"
    dest: ./
  notify: firewall open tomcat

- name: unarchive tomcat
  unarchive:
    src: ./apache-tomcat-9.0.71.tar.gz
    dest: ./
    remote_src: yes
  notify: started tomcat
EOF

# 시스템 실행 및 방화벽 포트 열기
cat > /root/galaxy/tomcat/handlers/main.yml << EOF
- name: "started {{ package }}"
  shell: |
    /root/apache-tomcat-9.0.71/bin/shutdown.sh
    sleep 5
    nohup /root/apache-tomcat-9.0.71/bin/startup.sh &
  become: yes
  become_user: root

- name: "firewall open {{ package }}"
  firewalld:
    port: 8080/tcp
    state: enabled
EOF
# 주석 처리
echo "#" > /root/galaxy/tomcat/defaults/main.yml << EOF
EOF
# tomcat role 파일 만들기
cat > /root/galaxy/tomcat.yml << EOF
- name: install galaxy tomcat
  hosts: test2
  roles:
    - tomcat
EOF

ansible-playbook tomcat.yml     
