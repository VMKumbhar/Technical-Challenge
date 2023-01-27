variable "project-name" {}
variable "vpc-id" {}
variable "shared-project" {}
variable "db-name" {}

variable "iam-roles" {
  description = "List of IAM resources to allow access to the pgsql db"
  type        = list(string)
  default     = [
    "roles/cloudsql.client"
    ]
}
