Usage
=====

```tf
provider "aws" {
    region = "us-east-2"
}

terraform {
    backend "s3" {
        region         = "us-east-2"
        bucket         = "salah-terraform-state"
        dynamodb_table = "salah-terraform-locks"
        key            = "state/name_of_state_file.tfstate"
        encrypt        = true
    }
}
```
