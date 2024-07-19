# ansible-galaxy

mkdir ~/galaxy
cd galaxy/
ansible-galaxy init tomcat
cp /root/server.xml /root/galaxy/tomcat/templates/server.xml.j2
cp /root/foryou.war /root/galaxy/tomcat/files/foryou.war

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


# 설치 및 파일copy
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

- name: server.xml copy
  template:
    src: server.xml.j2
    dest: /root/apache-tomcat-9.0.71/conf/server.xml
    owner: root
    group: root
   # become: yes
   # become_user: root
   # remote_src: yes

- name: foryou.war copy
  copy:
    src: foryou.war
    dest: /root/apache-tomcat-9.0.71/webapps/foryou.war
    owner: root
    group: root
  notify: restarted tomcat
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

- name: "restarted {{ package }}"
  shell: |
    /root/apache-tomcat-9.0.71/bin/shutdown.sh
    sleep 5
    nohup /root/apache-tomcat-9.0.71/bin/startup.sh &
  become: yes
  become_user: root

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
