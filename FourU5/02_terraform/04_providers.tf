terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.57"
    }
  }
  /*
   backend "s3" {
     bucket         = "foryou-terraform-state"      # S3 버킷 이름
     key            = "terraform/terraform.tfstate" # tfstate 저장 경로
     region         = "ap-northeast-2"              # S3 리전 위치
     dynamodb_table = "foryou-terraform-state-lock2"# dynamodb table 이름
     encrypt        = true                          # 암호화
   }
   */
}

provider "aws" {
  region = var.region
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "local_file" "k8_ssh_key" {
  filename        = "${var.name}_key.pem"
  file_permission = "600"
  content         = tls_private_key.ssh.private_key_pem
}

resource "aws_key_pair" "k8_ssh" {
  key_name   = "${var.name}_ssh"
  public_key = tls_private_key.ssh.public_key_openssh
}