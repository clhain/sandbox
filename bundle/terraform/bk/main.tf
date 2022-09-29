
locals {
  cluster_name = "${var.name}"
  # network_name = "${var.name}-vpc"
  primary_subnet_name = "${var.name}-primary-subnet"
  pod_subnet_name = "${var.name}-pods"
  service_subnet_name = "${var.name}-services"
  common_labels = {
    "owner" = var.name,
  }
}

provider "google" {
  project = var.gcp_project_id
  region = var.gcp_region
  credentials = "/cnab/app/gcloud.json"
}

data "google_service_account" "this" {
  account_id = var.node_service_account_id
}

data "google_compute_network" "this" {
  count = var.create_network ? 0 : 1
  name  = var.network_name
}

data "google_compute_subnetwork" "this" {
  count  = var.create_network ? 0 : 1
  name   = data.google_compute_network.this.name
  region = var.gcp_region
}

###################################################
# VPC
###################################################
module "gcp_network" {
  count  = var.create_network ? 1 : 0
  source       = "terraform-google-modules/network/google"
  version      = "~> 4.0"
  project_id     = var.project
  network_name = var.network_name
  subnets = [
    {
      subnet_name   = local.primary_subnet_name
      subnet_ip     = var.primary_subnet_range
      subnet_region = var.region
    },
  ]
}

###################################################
# Static IP For Cluster Ingress Service
###################################################
resource "google_compute_address" "cluster_ingress" {
  name         = "${var.name}-cluster-ingress"
  subnetwork = upper(var.cluster_ingress_ip_type)=="INTERNAL" ? (var.create_network ? module.gcp_network.subnets_names[0] : data.google_compute_subnetwork.this.self_link) : null
  address_type = upper(var.cluster_ingress_ip_type)
  region       = var.gcp_region
}

###################################################
# Cluster
###################################################
resource "google_container_cluster" "default" {
  name        = local.cluster_name
  project     = var.gcp_project_id
  description = "Sandbox GKE Cluster"
  location    = var.gcp_region

  //remove_default_node_pool = true
  initial_node_count       = var.initial_node_count

  # provider = google-beta
  network  = var.create_network ? module.gcp_network.network_name : data.google_compute_network.this.self_link
  subnetwork = var.create_network ? module.gcp_network.subnets_names[0] : data.google_compute_subnetwork.this.self_link
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
  private_cluster_config {
    enable_private_nodes    = var.enable_private_nodes
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
