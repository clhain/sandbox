
locals {
  cluster_name = "${var.name}"
  # network_name = "${var.name}-vpc"
  # pod_subnet = "${var.name}-pods"
  # service_subnet = "${var.name}-services"
  common_labels = {
    "owner" = var.name,
  }
}

provider "google" {
  project = var.gcp_project_id
  region = var.gcp_region
  credentials = "/cnab/app/gcloud.json"
}

data "google_compute_network" "this" {
  name = var.network_name
}

data "google_compute_subnetwork" "this" {
  name   = data.google_compute_network.this.name
  region = var.gcp_region
}

data "google_service_account" "this" {
  account_id = var.node_service_account_id
}

###################################################
# Static IP For Cluster Ingress Service
###################################################
resource "google_compute_address" "cluster_ingress" {
  name         = "${var.name}-cluster-ingress"
  subnetwork = upper(var.cluster_ingress_ip_type)=="INTERNAL" ? data.google_compute_subnetwork.this.self_link : null
  address_type = upper(var.cluster_ingress_ip_type)
  region       = var.gcp_region
}

###################################################
# Cluster
###################################################
resource "google_container_cluster" "default" {
  name        = local.cluster_name
  project     = var.gcp_project_id
  description = "Demo GKE Cluster"
  location    = var.gcp_region

  //remove_default_node_pool = true
  initial_node_count       = var.initial_node_count

  # provider = google-beta
  # network  = module.gcp_network.network_name
  # subnetwork = module.gcp_network.subnets_names[0]
  # ip_allocation_policy {
  #   cluster_secondary_range_name = "${var.name}-pod-subnet"
  #   services_secondary_range_name = "${var.name}-service-subnet"
  # }

  node_config {
    service_account = data.google_service_account.this.email
    machine_type = var.machine_type
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only"
    ]
    tags = ["f5-demo-cluster"]
  }
  master_auth {
    client_certificate_config {
      issue_client_certificate = true
    }
  }
  depends_on = [google_compute_address.cluster_ingress]
}


data "google_client_config" "default" {
}

data "template_file" "kubeconfig" {
  template = file("${path.module}/templates/kubeconfig-template.yaml")

  vars = {
    cluster_name  = google_container_cluster.default.name
    endpoint      = google_container_cluster.default.endpoint
    cluster_ca    = google_container_cluster.default.master_auth[0].cluster_ca_certificate
    cluster_token = data.google_client_config.default.access_token
  }
}

resource "local_file" "kubeconfig" {
  content         = data.template_file.kubeconfig.rendered
  filename        = "${path.root}/kubeconfig"
  file_permission = "0600"
}
