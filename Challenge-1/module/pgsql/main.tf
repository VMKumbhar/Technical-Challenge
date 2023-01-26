resource "google_service_account" "pgsql-sa" {
  project = "${var.project-name}"
  account_id   = "pgsql-service-account"
  display_name = "Service Account"
}

resource "google_project_iam_member" "sa-mem" {
  project = "${var.project-name}"
  count = length(var.iam-roles)
  role    = format("%s", element(var.iam-roles, count.index))
  member = "serviceAccount:${google_service_account.pgsql-sa.email}"
}


resource "google_compute_global_address" "private_ip_address" {
  name          = "private-ip-address-1"
  project       = "${var.shared-project}"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = "${var.vpc-id}"
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = "${var.vpc-id}"
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "google_sql_database_instance" "pgsql-instance" {
  name   = "${var.db-name}"
  region = "europe-west1"
  project = "${var.project-name}"
  database_version = "POSTGRES_12"
  #depends_on = [google_service_networking_connection.private_vpc_connection]
  deletion_protection = false
  settings {
    tier = "db-custom-4-15360"
    user_labels = {
      "env" = "prod"
    }
    backup_configuration {
     #binary_log_enabled = true
      enabled = true
      start_time = "5:00"
	  point_in_time_recovery_enabled = true
          location = "eu"
          transaction_log_retention_days = "1"
    }
    maintenance_window {
      day  = "7"
      hour = "3"
    }	
    ip_configuration {
      ipv4_enabled    = false
      private_network = "${var.vpc-id}"
    }
    availability_type = "REGIONAL"
    activation_policy = "ALWAYS"
    database_flags {
      name = "max_connections"
      value = "400"
    }
    database_flags {
	    name = "temp_file_limit"
	    value = "4194304"
	  }
    insights_config {
      query_insights_enabled  = true
      query_string_length     = 1024
      record_application_tags = true
      record_client_address   = true
    }
    disk_type = "PD_SSD"
    disk_size = 500
  }
}
