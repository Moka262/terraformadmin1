terraform {
  backend "s3" {
    bucket = "devopsb21terraform"
    key    = "terraform/mytfstate.state"
    region = "us-east-1"
  }
}