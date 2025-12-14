terraform {
required_version = ">= 1.0"

backend "s3" {
 bucket = "dipeshbucket4practice" # CHANGE
 key = "developer4practice/dev.tfstate" # CHANGE
 region = "eu-north-1" # CHANGE
}
}
