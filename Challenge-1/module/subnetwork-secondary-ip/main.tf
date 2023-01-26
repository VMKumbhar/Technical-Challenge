resource "google_compute_subnetwork" "subnet" {
  project = "${var.shared-project}"
  network = "${var.subnet-vpc}"
  name = "${var.subnet-name}"
  private_ip_google_access = true
  ip_cidr_range = "${var.subnet-ip}"
  region = "${var.region}"
   secondary_ip_range {
    range_name    = "${var.gke-pod-ip-address-name}"
    ip_cidr_range = "${var.gke-pod-ip-address}"
   }
   secondary_ip_range {
    range_name = "${var.gke-svc-ip-address-name}"
    ip_cidr_range = "${var.gke-svc-ip-address}"
  }
}


output "gke-subnet-self-link" {
  description = "A reference (self_link) to the public subnetwork"
  value       = google_compute_subnetwork.subnet.self_link
}

output "gke-secondary-pod-name" {
  value = "${google_compute_subnetwork.subnet.secondary_ip_range.0.range_name}"
}

output "gke-secondary-svc-name" {
  value = "${google_compute_subnetwork.subnet.secondary_ip_range.1.range_name}"
}


