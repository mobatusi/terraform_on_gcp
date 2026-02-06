variable "project_id" {
  type    = string
  default = "dolu-sandbox-408209"
}

variable "region" {
  type    = string
  default = "us-east1"
}

variable "state_bucket" {
  type    = string
  default = "terraform-state-dolu-sandbox-408209"
}

variable "cluster_name" {
  type    = string
  default = "poc-terraform"
}

variable "service_name" {
  type    = string
  default = "poc-terraform-sample"
}

variable "k8s_version" {
  type = string
  default = 1.24
}

variable "min_node_count" {
  type    = number
  default = 1
}

variable "max_node_count" {
  type    = number
  default = 3
}

variable "machine_type" {
  type    = string
  default = "e2-standard-2"
}

variable "preemptible" {
  type    = bool
  default = true
}

variable "artifact_registry_repository" {
  type    = string
  default = "docker-repo"
}

variable "cloud_run_image_name" {
  type    = string
  default = "terraform-gcp-app"
}

variable "cloud_run_image_tag" {
  type    = string
  default = "latest"
}
