variable "name" {
  default = "unknown-user"
}
variable "gcp_project_id" {
  default = "f5-gcs-7506-ptg-edge-octo-dev"
}
variable "network_name" {
  default = "default"
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