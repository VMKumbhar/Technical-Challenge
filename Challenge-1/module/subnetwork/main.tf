resource "google_compute_subnetwork" "subnet" {
  project = "${var.shared-project}"
  network = "${var.subnet-vpc}"
  name = "${var.subnet-name}"
  private_ip_google_access = "${var.private_ip_google_access}"
  ip_cidr_range = "${var.subnet-ip}"
  region = "${var.region}"
  depends_on  = ["google_compute_network.vpc"]
}

output "pvt-subnet-self-link" {
  description = "A reference (self_link) to the public subnetwork"
  value       = google_compute_subnetwork.subnet.self_link
}
