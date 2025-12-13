terraform {
  backend "s3" {
    bucket = "dipeshbucket4practice"
    key    = "production4practice/Jenkins.tfstate"
    region = "eu-north-1"
  }
}
