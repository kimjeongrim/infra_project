terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.57"
    }
  }

  # backend "s3" {
  #   bucket         = "foryou-terraform-state"      # S3 버킷 이름
  #   key            = "terraform/terraform.tfstate" # tfstate 저장 경로
  #   region         = "ap-northeast-2"              # S3 리전 위치
  #   dynamodb_table = "foryou-terraform-state-lock" # dynamodb table 이름
  #   encrypt        = true                          # 암호화
  # }
}

provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_key_pair" "public_key" {
  key_name   = "foryou"
  public_key = file("foryou.pub")
}
