variable "project-name" {}
variable "region" {}
variable "gkename" {}
variable "gke-machine-type" {}
variable "gke-image-type" {
  default = "COS"
}
variable "vpc-id" {}
variable "gke-subnet" {}
variable "number-of-nodes" {}
variable "gke-node-name" {}
variable "master-cidr-ip" {}
variable "gke-pod-network" {}
variable "gke-service-network" {}

variable "iam-roles" {
  description = "List of IAM resources to allow access to the GKE"
  type        = list(string)
  default     = [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/stackdriver.resourceMetadata.writer",
    "roles/storage.objectViewer",
    "roles/artifactregistry.reader",
    "roles/autoscaling.metricsWriter",
    "roles/cloudtrace.agent",
    "roles/container.clusterViewer",
    "roles/opsconfigmonitoring.resourceMetadata.writer",
    "roles/servicemanagement.serviceController",
    #"roles/servicemanagement.serviceConsumer"
    ]
}


