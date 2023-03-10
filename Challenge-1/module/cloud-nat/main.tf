
//Asign static IP address
resource "google_compute_address" "address" {
  project = "${var.project-name}"
  count  = 2
  name   = "${var.cloud-nat-static-ip}-${count.index}"
  region = "${var.nat-subnet-region}"
}

//Here we create a cloud router for getting internet access
resource "google_compute_router" "router" {
  project = "${var.project-name}"
  name    = "${var.router-name}"
  region  = "${var.nat-subnet-region}"
  network = "${var.nat-network}"
  bgp {
    asn = 64514
  }
}

//Create a Cloud NAT for BAstionhost Ineternet Access
resource "google_compute_router_nat" "nat" {
  project = "${var.project-name}"    
  name    = "${var.cloud-nat-name}"
  router  = "${google_compute_router.router.name}"
  region  = "${var.nat-subnet-region}"
  nat_ip_allocate_option = "MANUAL_ONLY"
  nat_ips = google_compute_address.address.*.id
  //source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    //here we sepecified the subnet to get the internet for access
    name                    = "${var.nat-subnetwork}"
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
  subnetwork {
    //here we sepecified the subnet to get the internet for access
    name                    = "${var.nat-subnetwork-gke}"
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
  subnetwork {
    //here we sepecified the subnet to get the internet for access
    name                    = "${var.nat-subnetwork-pub}"
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }  
  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
