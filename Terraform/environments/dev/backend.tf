terraform {
  backend "oss" {
    bucket  = "terraform-state-devops01"
    prefix  = "dev/terraform.tfstate"
    region  = "cn-hangzhou"
    key     = "devops1/dev.terraform.tfstate"
    encrypt = true
    acl     = "private"
  }
}