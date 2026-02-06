# IMPORTANT: This Terraform configuration manages GCP resources, NOT the project itself
# When destroying resources with 'terraform destroy', only Terraform-managed resources are deleted
# DO NOT delete the GCP project - keep it for future use (projects are free when no resources run)
# To avoid charges, destroy resources but keep the project

terraform {
  backend "gcs" {
    bucket      = "terraform-state-dolu-sandbox-408209"
    prefix      = "terraform/state"
    credentials = "account.json"
  }
}

provider "google" {
  credentials = file("account.json")
  project     = var.project_id
  region      = var.region
}

resource "google_storage_bucket" "state" {
     name     = var.state_bucket
     location = var.region
     project  = var.project_id
     storage_class = "STANDARD"
     force_destroy = true 
     versioning {
                 enabled = true
      }
}

resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region
  project  = var.project_id

  # Remove default node pool, we'll create a separate one
  remove_default_node_pool = true
  initial_node_count       = 1

  # Disable deletion protection to allow cluster deletion via Terraform
  # NOTE: This only affects the GKE cluster, NOT the GCP project itself
  # NEVER delete the GCP project - only destroy Terraform-managed resources
  deletion_protection = false

  # Network configuration
  network    = "default"
  subnetwork = "default"

  # Enable logging and monitoring
  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  # Resource labels
  resource_labels = {
    environment = "development"
    managed-by  = "terraform"
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.cluster_name}-node-pool"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  project    = var.project_id
  node_count = var.min_node_count

  # Node configuration subblock
  node_config {
    machine_type = var.machine_type
    disk_size_gb = 100
    disk_type    = "pd-standard"
    preemptible  = var.preemptible

    # OAuth scopes
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    # Labels for nodes
    labels = {
      environment = "development"
      managed-by  = "terraform"
    }

    # Metadata
    metadata = {
      disable-legacy-endpoints = "true"
    }

    # Tags
    tags = ["gke-node", "${var.cluster_name}-node"]
  }

  # Management subblock
  management {
    auto_repair  = true
    auto_upgrade = true
  }

  # Autoscaling subblock
  autoscaling {
    min_node_count = var.min_node_count
    max_node_count = var.max_node_count
  }
}

# Artifact Registry Repository
resource "google_artifact_registry_repository" "docker_repo" {
  location      = var.region
  repository_id = var.artifact_registry_repository
  description   = "Docker repository for container images"
  format        = "DOCKER"
  project       = var.project_id
}

# IAM Policy Binding for Artifact Registry - Writer role for GKE nodes
resource "google_artifact_registry_repository_iam_binding" "docker_repo_iam_writer" {
  location   = var.region
  repository = google_artifact_registry_repository.docker_repo.repository_id
  role       = "roles/artifactregistry.writer"
  project    = var.project_id
  members = [
    "serviceAccount:${data.google_compute_default_service_account.default.email}",
  ]
}

# IAM Policy Binding for Artifact Registry - Reader role for service account
resource "google_artifact_registry_repository_iam_binding" "docker_repo_iam_reader" {
  location   = var.region
  repository = google_artifact_registry_repository.docker_repo.repository_id
  role       = "roles/artifactregistry.reader"
  project    = var.project_id
  members = [
    "serviceAccount:educative-service-account@${var.project_id}.iam.gserviceaccount.com",
  ]
}

# Data source to get default compute service account
data "google_compute_default_service_account" "default" {
  project = var.project_id
}

# Enable Cloud Run API
resource "google_project_service" "cloud_run_api" {
  project = var.project_id
  service = "run.googleapis.com"

  disable_on_destroy = false
}

# Fetch IAM policy for Cloud Run service
data "google_iam_policy" "cloud_run_public_access" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

# Cloud Run Service
resource "google_cloud_run_service" "app" {
  name     = var.service_name
  location = var.region
  project  = var.project_id

  template {
    spec {
      containers {
        image = "${var.region}-docker.pkg.dev/${var.project_id}/${var.artifact_registry_repository}/${var.cloud_run_image_name}:${var.cloud_run_image_tag}"

        ports {
          container_port = 8080
        }

        resources {
          limits = {
            cpu    = "1000m"
            memory = "512Mi"
          }
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  depends_on = [google_project_service.cloud_run_api]
}

# Assign public access to Cloud Run service
resource "google_cloud_run_service_iam_policy" "app_iam_policy" {
  location    = google_cloud_run_service.app.location
  project     = google_cloud_run_service.app.project
  service     = google_cloud_run_service.app.name
  policy_data = data.google_iam_policy.cloud_run_public_access.policy_data
}