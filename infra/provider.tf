terraform {
  required_version = ">= 1.0.0"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.21.0"
    }
  }
}

provider "aws" {

}