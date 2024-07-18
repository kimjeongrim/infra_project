provider "aws" {
  region = "ap-northeast-2"
}

# 테라폼 상태파일 저장용 S3버킷
resource "aws_s3_bucket" "terraform-state" {
  bucket = "foryou-terraform-state"

  tags = {
    Stage = "Common" # 버킷 사용 단계
    Name  = "terraform-state" # 버킷 이름 태그
  }

  lifecycle {
    prevent_destroy = false # 리소스 삭제 방지(true!!!)
  }
}

# 테라폼 상태 파일 버전 관리 설정
resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform-state.bucket
 
  # 버전 관리 활성화 
  versioning_configuration {
    status = "Enabled" # 상태 파일 변경 이력 유지
  }
}

# dynamoDB 테이블 생성
resource "aws_dynamodb_table" "terraform-state-lock" {
   name           = "foryou-terraform-state-lock" # 테라폼 상태 파일 잠금 관리
  billing_mode   = "PAY_PER_REQUEST" # 사용한 만큼 요금 부과
  hash_key       = "LockID" # 해시키

  # 테이블 속성 정의
  attribute {
    name = "LockID" # 속성명
    type = "S" # 문자열
  }

  tags = {
    Stage = "Common" # 테이블 사용 단계
    Name  = "terraform-state-lock" # 테이블 이름 태그
  }
}
