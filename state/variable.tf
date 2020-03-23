variable "aws_region" {
  description         = "AWS Data Center Region"
  default             = "us-east-2"
}

variable "state_key_prefix" {
  description         = "Key Prefix in s3 bucket of state files"
  default             = "states"
}

variable "state_bucket" {
  description         = "Bucket to keep state files"
  default             = "salah-terraform-state"
}

variable "dynamodb_table" {
  description         = "Table to keep track of locking"
  default             = "salah-terraform-locks"
}
