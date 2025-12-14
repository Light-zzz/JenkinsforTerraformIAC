terraform {
required_version = ">= 1.0"

backend "s3" {
 bucket = "dipeshbucket4practice" # CHANGE
 key = "production4practice/Jenkins.tfstate" # CHANGE
 region = "eu-north-1" # CHANGE
}
}
