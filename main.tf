provider "google" {
}

resource "google_storage_bucket" "terraform-state" {
    name = "prod-state"
    project = "app-prod"
    location = "US"
    versioning {
      enabled = true
    }
}

module "pvt-subnetwork-euw1-1" {
  source = "../modules/subnetwork"
  shared-project = "${var.shared-project}"
  subnet-vpc = "${var.vpc-name}"
  region = "${var.region-euw1}"
  subnet-name = "${var.pvt-subnet-name-euw1-1}"
  subnet-ip = "${var.pvt-subnet-ip-range-euw1-1}"
  private_ip_google_access = true
}

module "pub-subnetwork-euw1-1" {
  source = "../modules/subnetwork"
  shared-project = "${var.shared-project}"
  subnet-vpc = "${var.vpc-name}"
  region = "${var.region-euw1}"
  subnet-name = "${var.pub-subnet-name-euw1-1}"
  subnet-ip = "${var.pub-subnet-ip-range-euw1-1}"
  private_ip_google_access = false
}

module "gke-subnetwork-euw1-1" {
  source = "../modules/subnetwork-secondary-ip"
  shared-project = "${var.shared-project}"
  subnet-vpc = "${var.vpc-name}"
  region = "${var.region-euw1}"
  subnet-name = "${var.gke-subnet-name-euw1-1}"
  subnet-ip = "${var.gke-subnet-ip-range-euw1-1}"
  gke-pod-ip-address-name = "${var.gke-pod-ip-name-euw1-1}"
  gke-pod-ip-address = "${var.gke-pod-ip-range-euw1-1}"
  gke-svc-ip-address-name = "${var.gke-svc-ip-name-euw1-1}"
  gke-svc-ip-address = "${var.gke-svc-ip-range-euw1-1}"
}


data "google_compute_network" "shared-network" {
    name = "${var.shared-network-name}"
    project = "${var.shared-project}"
}

data "google_compute_subnetwork" "shared-prod-pvt-subnetwork" {
  project = "${var.shared-project}"
  name   = "${var.prod-private-subnet}"
  region = "us-central1"
}

data "google_compute_subnetwork" "shared-gke-subnetwork" {
  project = "${var.shared-project}"
  name   = "${var.prod-gke-subnet}"
  region = "us-central1"
}

data "google_compute_subnetwork" "shared-prod-pub-subnetwork" {
  project = "${var.shared-project}"
  name   = "${var.prod-public-subnet}"
  region = "us-central1"
}


data "google_compute_subnetwork" "shared-prod-pvt-subnetwork-euw1-1" {
  project = "${var.shared-project}"
  name   = "${var.prod-private-subnet-euw1-1}"
  region = "europe-west1"
}

data "google_compute_subnetwork" "shared-prod-gke-subnetwork-euw1-1" {
  project = "${var.shared-project}"
  name   = "${var.prod-gke-subnet-euw1-1}"
  region = "europe-west1"
}

data "google_compute_subnetwork" "shared-prod-pub-subnetwork-euw1-1" {
  project = "${var.shared-project}"
  name   = "${var.prod-public-subnet-euw1-1}"
  region = "europe-west1"
}

module "cloud-subnet-nat-euw1-1" {
  source = "../modules/cloud-nat"
  project-name = "${var.shared-project}"
  router-name = "${var.cloud-router-name-euw1-1}"
  cloud-nat-name = "${var.cloud-nat-name-euw1-1}"
  nat-subnet-region = "${var.cloud-nat-subnet-region-euw1}"
  cloud-nat-static-ip = "${var.cloud-nat-static-ip-euw1}"
  nat-network = "${data.google_compute_network.shared-network.self_link}"
  nat-subnetwork = "${data.google_compute_subnetwork.shared-prod-pvt-subnetwork-euw1-1.self_link}"
  nat-subnetwork-gke = "${data.google_compute_subnetwork.shared-prod-gke-subnetwork-euw1-1.self_link}"
}

module "pgsql" {
  source = "../modules/pgsql"
  project-name = "${var.project-name}"
  db-name = "${var.db-name}"
  vpc-id = "${data.google_compute_network.shared-network.self_link}"
}

module "gke" {
  source = "../modules/gke"
  project-name = "${var.project-name}"
  vpc-id = "${data.google_compute_network.shared-network.self_link}"
  region = "${var.region-euw1}"
  gkename = "${var.gkename}"
  gke-machine-type = "${var.gke-machine-type}"
  gke-subnet = "${data.google_compute_subnetwork.shared-prod-gke-subnetwork-euw1-1.self_link}"
  gke-pod-network = "${var.prod-gke-subnet-pod-ip-euw1-1}"
  gke-service-network =  "${var.prod-gke-subnet-svc-ip-euw1-1}"
  number-of-nodes = "${var.number-of-nodes}"
  gke-node-name = "${var.gke-node-name}"
  master-cidr-ip = "${var.master-cidr-ip}"
}


resource "google_compute_firewall" "prod-gke-fw-rule" {
  project = "${var.shared-project}"
  name = "${var.gke-firewall-rule-name}"
  network = "shared-vpc"
  allow {
      protocol = "tcp"
      ports = ["80"]
  }

  source_tags = ["${var.developer-vm-tag}"]  
  target_tags = ["${var.gke-tag}"]   
}

resource "google_binary_authorization_policy" "policy" {
  project = var.project-name  

  global_policy_evaluation_mode = "ENABLE"

  admission_whitelist_patterns {
    name_pattern = "gcr.io/google_containers/*" 
  }

  admission_whitelist_patterns {
    name_pattern = "gcr.io/google-containers/*"
  }

  admission_whitelist_patterns {
    name_pattern = "k8s.gcr.io/*"
  }

  admission_whitelist_patterns {
    name_pattern = "gke.gcr.io/*"
  }

  admission_whitelist_patterns {
    name_pattern = "gcr.io/stackdriver-agents/*"
  }

  admission_whitelist_patterns {
    name_pattern = "gcr.io/cts-shared-devops/*"
  }

  admission_whitelist_patterns {
    name_pattern = "gcr.io/endpoints-release/*"
  }

  admission_whitelist_patterns {
    name_pattern = "gcr.io/projectcalico-org/*"
  }

  admission_whitelist_patterns {
    name_pattern = "gcr.io/prj-devops-prod/*"
  }


  default_admission_rule {
    evaluation_mode  = "ALWAYS_DENY"
    enforcement_mode = "ENFORCED_BLOCK_AND_AUDIT_LOG"
  }

  cluster_admission_rules {
    cluster                 = "europe-west1.prod-gke-euw1"
    evaluation_mode         = "ALWAYS_DENY"
    enforcement_mode        = "ENFORCED_BLOCK_AND_AUDIT_LOG"
  }
}


