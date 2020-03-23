provider "aws" {
    region = var.aws_region
}

data "aws_canonical_user_id" "current_user" {}

resource "aws_s3_bucket" "terraform_state" {
    bucket = var.state_bucket
    versioning {
        enabled     = true
    }

    grant {
        id          = data.aws_canonical_user_id.current_user.id
        type        = "CanonicalUser"
        permissions = ["FULL_CONTROL"]
    }
}


resource "aws_dynamodb_table" "terraform_locks" {
    name         = var.dynamodb_table
    billing_mode = "PAY_PER_REQUEST"
    hash_key     = "LockID" 
    attribute {
        name = "LockID"
        type = "S"
    }
}
