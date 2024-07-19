# infra_project
terraform + ansible + k8s + eks

#### RDS 읽기 전용 복제본
rds-rep.tf 
ingress 3306 추가 필요

#### tomcat war 배포 시
server.xml, foryou.war 필요

✔ server.xml 추가
#<Context path="[경로]" docBase="[파일이름]"  reloadable="false" > </Context>
<Context path="/root/apache-tomcat-9.0.71/webapps" docBase="foryou.war"  reloadable="false" > </Context>
