terraform {
  backend "gcs" {
    bucket = "prod-state"
  }
}
