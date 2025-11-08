terraform {
  backend "s3" {
    bucket       = "url-shortener-for-tfstate"
    key          = "infra/terraform.tfstate"
    region       = "eu-west-2"
    encrypt      = true
    use_lockfile = true
  }
}