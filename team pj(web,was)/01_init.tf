terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_key_pair" "foryou_key" {
  key_name   = "${var.name}"
  public_key = file("foryou_key.pub")
}
