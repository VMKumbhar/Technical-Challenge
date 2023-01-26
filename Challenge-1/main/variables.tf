//Projects
variable "shared-project" {
    default = "shared-network"
}

variable "project-name" {
    default = "prj-app-prod"
}

variable "prod-devops-project" {
    default = "prj-devops-prod"
 }

variable "vpc-name" {
    default = "shared-vpc"
}

variable "shared-control-proj" {
   default = "shared-devops"
}

variable "region-euw1" {
  default = "europe-west1"
}

variable "private_ip_google_access" {
  default = "true"
}

variable "pvt-subnet-name-euw1-1" {
    default = "prod-private-subnet-euw1-1"
}

variable "pvt-subnet-ip-range-euw1-1" {
    default = "*.*.*.*/18"
}

variable "pub-subnet-name-euw1-1" {
    default = "prod-public-subnet-euw1-1"
}

variable "pub-subnet-ip-range-euw1-1" {
    default = "*.*.*.*/18"
}


variable "gke-subnet-name-euw1-1" {
    default = "prod-gke-subnet-euw1-1"
}

variable "gke-subnet-ip-range-euw1-1" {
    default = "*.*.*.*/22"
}

variable "gke-pod-ip-name-euw1-1" {
    default = "gke-pod-ip-address-euw1-1"
}

variable "gke-pod-ip-range-euw1-1" {
    default = "10.118.0.0/18"
}

variable "gke-svc-ip-name-euw1-1" {
    default = "gke-svc-ip-address-euw1-1"
}

variable "gke-svc-ip-range-euw1-1" {
    default = "*.*.*.*/18"
}

//Developer VM



//Firwall Details

variable "gke-firewall-rule-name" {
    default = "prod-gke-developervm"
}

//PGDB Name
variable "db-name" {
  default = "prod-pgsql-db-euw1"
}


//VPC network and subnetwork
variable "shared-network-name" {
    default = "shared-vpc"
}

variable "prod-private-subnet-euw1-1" {
    default = "prod-private-subnet-euw1-1"
}

variable "prod-gke-subnet-euw1-1" {
    default = "prod-gke-subnet-euw1-1"
}

variable "prod-public-subnet-euw1-1" {
    default = "prod-public-subnet-euw1-1"
}


//Nat Router Details

variable "cloud-router-name-euw1-1" {
    default = "prod-nat-rt-euw1-1"
}

variable "cloud-nat-name-euw1-1" {
  default = "prod-nat-euw1-1"
}

variable "cloud-nat-static-ip-euw1" {
  default = "prod-nat-static-ip-euw1"
}

variable "cloud-nat-subnet-region-euw1" {
  default = "europe-west1"
}

//GKE Details

variable "gkename" {
  default = "prod-gke-euw1"
}


variable "gke-pool-name" {
  default = "prod-gke-nodepool"
}

variable "number-of-nodes" {
  default = 1
}

variable "gke-node-name" {
  default = "prod-gke-nodes"
}

variable "master-cidr-ip" {
  default = "172.16.0.32/28"
}

variable "gke-machine-type" {
  default = "n1-standard-4"
}

variable "prod-gke-subnet-pod-ip-euw1-1" {
  default = "gke-pod-ip-address-euw1-1"
}

variable "prod-gke-subnet-svc-ip-euw1-1" {
  default = "gke-svc-ip-address-euw1-1"
}

variable "gke-tag" {
  default = "gke"
}

