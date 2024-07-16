module "pjt" {
  source = "../team pj(web,was)"

  region = "ap-northeast-2"
  name = "foryou"
  cidr = "10.0.0.0/16"
  pri = "10.0.0.21"
  type = "t2.micro"
  load = "application"
  tenancy = "default"
  bool0 = false
  bool1 = true
  ssh = "ssh"
  http = "http"
  mysql = "mysql"
  icmp = "icmp"
  protcp = "tcp"
  proudp = "udp"
  proicmp = "icmp"
  sshport = 22
  httpport = 80
  mysqlport = 3306
  icmpport = -1
  dert = "0.0.0.0/0"
  dert6 = "::/0"
  dbtype = "db.t3.micro"
  dbname = "wordpress"
  dbidentifier = "cyidb"
  dbusername = "root"
  dbpassword = "It12345!"
  ssdtype = "gp2"
  subip = "10.0."
  lb_type = "application"
  route53 = "ogurim.store"
  route53_www = "www.ogurim.store"
  route_type = "A"
  bucket_ownership = "BucketOwnerPreferred"
  bucket_type = "CanonicalUser"
  bucket_permission = "FULL_CONTROL"
  bucket_filename = "0.png"
  bucket_acl = "public-read-write"
  content_type = "image/png"
  }

  output "eip_no" {
    value = "${module.pjt.eip_no}"
  }

  output "name_server" {
    value = "${module.pjt.name_server}"
  }

  output "ec2_publicip_web" {
    value = "${module.pjt.ec2_publicip_web}"
  }

  output "load_dns_web" {
    value = "${module.pjt.load_dns_web}"
  }
