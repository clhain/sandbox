output "cluster_endpoint" {
  description = "The IP address of the cluster master."
  sensitive   = true
  value       = module.gke_cluster.endpoint
}

output "client_certificate" {
  description = "Public certificate used by clients to authenticate to the cluster endpoint."
  value       = module.gke_cluster.client_certificate
}

output "client_key" {
  description = "Private key used by clients to authenticate to the cluster endpoint."
  sensitive   = true
  value       = module.gke_cluster.client_key
}

output "cluster_ca_certificate" {
  description = "The public certificate that is the root of trust for the cluster."
  sensitive   = true
  value       = module.gke_cluster.cluster_ca_certificate
}

output "kubeconfig_file" {
  value = local_file.kubeconfig.filename
}

output "kubeconfig_content" {
  value = local_file.kubeconfig.content
  sensitive   = true
}

output "cluster_ingress_ip" {
  description = "Static IP of the GKE Cluster Ingress"
  value = google_compute_address.cluster_ingress.address
}