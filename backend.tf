terraform {
  backend "gcs" {
    bucket = "terraform-state-bucket-mmarcetic"
    prefix = "terraform/state"
  }
}
