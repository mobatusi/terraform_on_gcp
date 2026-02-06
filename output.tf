output "project_id" {
  description = "The name of the project"
  value       = var.project_id
}

output "state_bucket" {
  description = "The name of the storage bucket that will store the state of the infrastructure"
  value       = var.state_bucket
}

output "cluster_name" {
  description = "The name of the deployed cluster"
  value       = var.cluster_name
}

output "k8s_version" {
  description = "The Kubernetes version used to deploy to the cluster"
  value       = var.k8s_version
}

output "region" {
  description = "The region where all the infrastructure is deployed"
  value       = var.region
}

output "cloud_run_url" {
  description = "The URL of the deployed Cloud Run service"
  value       = google_cloud_run_service.app.status[0].url
}