variable "router-name" {}

variable "cloud-nat-name" {}

variable "nat-network" {}

variable "nat-subnet-region" {
    default = "europe-west1"
}

variable "cloud-nat-static-ip" {}
variable "project-name" {}

variable "nat-subnetwork" {
   type = list(string)
   default = ["prod-private-subnet", "prod-gke-subnet"]
}


variable "nat-subnetwork-gke" {}

variable "nat-subnetwork-pub" {}

variable "static-nat-ip" {
    default = "cloud-nat-static-ip"
}
