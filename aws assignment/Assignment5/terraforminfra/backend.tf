terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "path/to/my/key"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "my-terraform-lock"
    acl            = "private"
  }
}
