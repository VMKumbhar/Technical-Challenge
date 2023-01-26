resource "google_service_account" "gke-sa-id" {
  project = "${var.project-name}"
  account_id   = "gke-service-account"
  display_name = "Service Account"
}

resource "google_project_iam_member" "sa-member" {
  project = "${var.project-name}"
  count = length(var.iam-roles)
  role    = format("%s", element(var.iam-roles, count.index))
  member = "serviceAccount:${google_service_account.gke-sa-id.email}"  
}

//Google private cluster creation
/* In this GKE cluster each varibale need to declare in variable.tf file.
her we are configured the private cluster with manualy created service account 
that also we need to declare in variable file.*/

resource "google_container_cluster" "cluster" {
  name = "${var.gkename}"
  project = "${var.project-name}"
  network = "${var.vpc-id}"
  subnetwork = "${var.gke-subnet}"
  location = "${var.region}"
  monitoring_service = "monitoring.googleapis.com/kubernetes"
  logging_service    = "logging.googleapis.com/kubernetes"
  remove_default_node_pool = "true"    
  initial_node_count = "${var.number-of-nodes}"
  enable_intranode_visibility = true
  enable_binary_authorization = true
  enable_shielded_nodes = true
  release_channel {
    channel = "STABLE"
  }

  
## In this session adding pods and service network to pods
  ip_allocation_policy {
    cluster_secondary_range_name = "${var.gke-pod-network}"
    services_secondary_range_name = "${var.gke-service-network}"
  }
  network_policy {
    enabled  = true
    provider = "CALICO"
  }
  addons_config {
    http_load_balancing {
      disabled = "false"
    }
    network_policy_config {
      disabled = "false"
    }   
  }
  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes = true
    //private master nodes with GCP CIDR ip address that is "*.*.*.*/28"
    //Master is not accessble from any other resources
    master_ipv4_cidr_block = "${var.master-cidr-ip}"
  }
  master_auth {
     username = ""
     password = ""

     client_certificate_config {
       issue_client_certificate = "false"
     }
  } 
  maintenance_policy {
    recurring_window {
      start_time = "2021-01-01T07:00:00Z"
      end_time = "2021-01-01T17:00:00Z"
      recurrence = "FREQ=WEEKLY;BYDAY=SA,SU"
    }
  }
} 


###############################################################################
/*Here am deleting the Defautl node and adding additional pool to GKE cluster
And all these node configuration details are mentioned in variable page */
###############################################################################
resource "google_container_node_pool" "node-pool-1" {
 name = "${var.gke-node-name}"
 project = "${var.project-name}"
 cluster = "${google_container_cluster.cluster.name}"
 location =  "${var.region}"
 node_count = "${var.number-of-nodes}"
 //Here we are declareing the private nodes machine type
 node_config {
   machine_type = "${var.gke-machine-type}"
   image_type = "COS"
   //Adding the service account node pool
   #service_account = "${var.service-account-details}"
   labels = {
     "cluster_env" = "production"
   }

   tags = [ "gke" ]
   service_account = "${google_service_account.gke-sa-id.email}"
    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_write",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append",
    ]
 }
 depends_on = [google_container_cluster.cluster]
}
