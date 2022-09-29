# Adapted from https://github.com/gruntwork-io/terraform-google-gke/tree/v0.10.0/examples/gke-private-cluster
# - Add support for "bring your own service account.
# - Add Machine type override
# - Preemtible node variable
# - Output Kubeconfig

# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY A GKE PRIVATE CLUSTER IN GOOGLE CLOUD PLATFORM
# This is an example of how to use the gke-cluster module to deploy a private Kubernetes cluster in GCP
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  # This module is now only being tested with Terraform 1.0.x. However, to make upgrading easier, we are setting
  # 0.12.26 as the minimum version, as that version added support for required_providers with source URLs, making it
  # forwards compatible with 1.0.x code.
  required_version = ">= 0.12.26"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.43.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 3.43.0"
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# PREPARE PROVIDERS
# ---------------------------------------------------------------------------------------------------------------------

provider "google" {
  project = var.project
  region  = var.region
  credentials = "/cnab/app/gcloud.json"
}

provider "google-beta" {
  project = var.project
  region  = var.region
  credentials = "/cnab/app/gcloud.json"
}

# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY A PRIVATE CLUSTER IN GOOGLE CLOUD PLATFORM
# ---------------------------------------------------------------------------------------------------------------------

module "gke_cluster" {
  source = "github.com/gruntwork-io/terraform-google-gke.git//modules/gke-cluster?ref=v0.10.0"

  name = var.cluster_name

  project  = var.project
  location = var.location
  network  = module.vpc_network.network

  # We're deploying the cluster in the 'public' subnetwork to allow outbound internet access
  # See the network access tier table for full details:
  # https://github.com/gruntwork-io/terraform-google-network/tree/master/modules/vpc-network#access-tier
  subnetwork                    = module.vpc_network.public_subnetwork
  cluster_secondary_range_name  = module.vpc_network.public_subnetwork_secondary_range_name
  services_secondary_range_name = module.vpc_network.public_services_secondary_range_name

  # When creating a private cluster, the 'master_ipv4_cidr_block' has to be defined and the size must be /28
  master_ipv4_cidr_block = var.master_ipv4_cidr_block

  # This setting will make the cluster private
  enable_private_nodes = "true"

  # To make testing easier, we keep the public endpoint available. In production, we highly recommend restricting access to only within the network boundary, requiring your users to use a bastion host or VPN.
  disable_public_endpoint = "false"

  # With a private cluster, it is highly recommended to restrict access to the cluster master
  # However, for testing purposes we will allow all inbound traffic.
  master_authorized_networks_config = [
    {
      cidr_blocks = [
        {
          cidr_block   = "0.0.0.0/0"
          display_name = "all-for-testing"
        },
      ]
    },
  ]

  enable_vertical_pod_autoscaling = var.enable_vertical_pod_autoscaling

}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE A NODE POOL
# ---------------------------------------------------------------------------------------------------------------------

resource "google_container_node_pool" "node_pool" {
  provider = google-beta

  name     = "private-pool"
  project  = var.project
  location = var.location
  cluster  = module.gke_cluster.name

  initial_node_count = var.initial_node_count

  autoscaling {
    min_node_count = "1"
    max_node_count = var.max_node_count
  }

  management {
    auto_repair  = "true"
    auto_upgrade = "true"
  }

  node_config {
    image_type   = "cos_containerd"
    machine_type = var.machine_type

    labels = {
      private-pool = "true"
      sandbox-node = "true"
    }

    # Add a private tag to the instances. See the network access tier table for full details:
    # https://github.com/gruntwork-io/terraform-google-network/tree/master/modules/vpc-network#access-tier
    tags = [
      module.vpc_network.private,
      "sandbox-node-pool",
    ]

    disk_size_gb = "30"
    disk_type    = "pd-standard"
    preemptible  = var.preemptible_nodes

    service_account = var.create_service_account ? module.gke_service_account.email : data.google_service_account.this[0].email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  lifecycle {
    ignore_changes = [initial_node_count]
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE A CUSTOM SERVICE ACCOUNT TO USE WITH THE GKE CLUSTER OR GET DATA FOR EXISTING
# ---------------------------------------------------------------------------------------------------------------------

module "gke_service_account" {
  count = var.create_service_account ? 1 : 0
  source = "github.com/gruntwork-io/terraform-google-gke.git//modules/gke-service-account?ref=v0.10.0"

  name        = var.cluster_service_account_name
  project     = var.project
  description = var.cluster_service_account_description
}

data "google_service_account" "this" {
  count = var.create_service_account ? 0 : 1
  account_id = var.cluster_service_account_name
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE A NETWORK TO DEPLOY THE CLUSTER TO
# ---------------------------------------------------------------------------------------------------------------------

module "vpc_network" {
  source = "github.com/gruntwork-io/terraform-google-network.git//modules/vpc-network?ref=v0.8.2"

  name_prefix = "${var.cluster_name}-network-${random_string.suffix.result}"
  project     = var.project
  region      = var.region

  cidr_block           = var.vpc_cidr_block
  secondary_cidr_block = var.vpc_secondary_cidr_block

  public_subnetwork_secondary_range_name = var.public_subnetwork_secondary_range_name
  public_services_secondary_range_name   = var.public_services_secondary_range_name
  public_services_secondary_cidr_block   = var.public_services_secondary_cidr_block
  private_services_secondary_cidr_block  = var.private_services_secondary_cidr_block
  secondary_cidr_subnetwork_width_delta  = var.secondary_cidr_subnetwork_width_delta
  secondary_cidr_subnetwork_spacing      = var.secondary_cidr_subnetwork_spacing
}

# Use a random suffix to prevent overlap in network names
resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE Reserved Static IP For Cluster Ingress
# ---------------------------------------------------------------------------------------------------------------------

resource "google_compute_address" "cluster_ingress" {
  name         = "${var.cluster_name}-ingress-static-${random_string.suffix.result}"
  subnetwork   = upper(var.cluster_ingress_ip_type)=="INTERNAL" ? var.vpc_cidr_block : null
  address_type = upper(var.cluster_ingress_ip_type)
  region       = var.region
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE Kubeconfig Content For Connection To The Cluster
# ---------------------------------------------------------------------------------------------------------------------

data "google_client_config" "default" {
}

data "template_file" "kubeconfig" {
  template = file("${path.module}/templates/kubeconfig-template.yaml")

  vars = {
    cluster_name  = module.gke_cluster.name
    endpoint      = module.gke_cluster.endpoint
    cluster_ca    = base64encode(module.gke_cluster.cluster_ca_certificate)
    cluster_token = data.google_client_config.default.access_token
  }
}

resource "local_file" "kubeconfig" {
  content         = data.template_file.kubeconfig.rendered
  filename        = "${path.root}/kubeconfig"
  file_permission = "0600"
}
