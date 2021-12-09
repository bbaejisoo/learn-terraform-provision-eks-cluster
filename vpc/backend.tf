# 내역을 versioning할 때
terraform {
  backend "s3" {
      bucket         = "jisoo-terraform-state"
      #key            = "jisoo-terraform-state/terraform.tfstate"
      key            = "tfstate/terraform.tfstate"
      region         = "ap-northeast-2"
      encrypt        = true
  }
}
