variable "name" {
  default = "unknown-user"
}
variable "gcp_project_id" {
  default = "f5-gcs-7506-ptg-edge-octo-dev"
}
variable "network_name" {
  default = "default"
}
variable "create_network" {
  default = false
}
variable "primary_subnet_range" {
  description = "The subnet to create as the primary if create_network = true"
  default = "10.240.0.0/16"
}
variable "enable_private_nodes" {
  description = "Set to enable private cluster nodes."
  default = false
}
variable "gcp_region" {
  default = "us-central1"
}
variable "initial_node_count" {
  default = 1
}
variable "machine_type" {
  default = "e2-standard-2"
}
variable "preemptible_nodes" {
  type    = bool
  default = true
}
variable "cluster_ingress_ip_type" {
  type = string
  default = "External"
}
variable "node_service_account_id" {
  type = string
}