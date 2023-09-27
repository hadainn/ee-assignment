terraform {
  backend "s3" {
    bucket  = "terraform-state-ee"
    key     = "environment/prod/prod.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}