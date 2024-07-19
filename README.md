# infra_project
terraform + ansible + k8s + eks

#### RDS 읽기 전용 복제본
rds-rep.tf 
Rocky Linux mysql  Ver 8.0.36
RDS mysql 8.0.36 사용
ingress 3306 추가 필요


#### tomcat 연동
✔ /etc/nginx/nginx.conf 추가
```
# 톰캣 연동 추가 IP 수정 필요
upstream tomcat {
  server 10.0.0.36:8080;
}
# 톰캣 연동 추가
location /{
  proxy_pass http://tomcat;
}
```

#### tomcat war 배포 시
server.xml, foryou.war 필요

✔ server.xml 추가
```
<Context path="[경로]" docBase="[파일이름]"  reloadable="false" > </Context>
<Context path="/root/apache-tomcat-9.0.71/webapps" docBase="foryou.war"  reloadable="false" > </Context>
```
