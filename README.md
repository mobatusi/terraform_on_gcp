# Manage Infrastructure Using Terraform on Google Cloud Platform

## Overview

This project demonstrates how to streamline containerized application deployment on Google Cloud Platform (GCP) through Infrastructure as Code (IaC) using Terraform. The project automates the provisioning and configuration of cloud infrastructure, including storage buckets, Kubernetes clusters, Artifact Registry, and Cloud Run deployments.

Terraform supports multiple cloud providers and can manage resources across different cloud environments and on-premises infrastructure, promoting flexibility and avoiding vendor lock-in. By automating infrastructure provisioning, this project reduces the risk of manual errors and ensures that environments are consistent and reproducible.

**Note**: A paid GCP account with billing enabled is required to complete this project. The cost is minimal (typically a few dollars) for setting up clusters and resources, unless services are heavily accessed.

## Technologies

- **Terraform** - Infrastructure as Code tool for provisioning and managing cloud resources
- **Google Cloud Platform (GCP)** - Cloud computing platform
- **Google Cloud Run** - Fully managed container platform for deploying applications
- **Google Kubernetes Engine (GKE)** - Managed Kubernetes service
- **Artifact Registry** - Docker image hosting and management service
- **gcloud CLI** - Command-line tool for interacting with Google Cloud services
- **Docker** - Containerization platform for packaging applications

## Project Structure

```
terraform_on_gcp/
├── README.md
├── LICENSE
├── implementation_steps.ipynb    # Jupyter notebook with all implementation steps
├── variables.tf                  # Terraform variable definitions
├── output.tf                     # Terraform output definitions
├── main.tf                       # Main Terraform configuration
├── Application/                  # Django application directory
│   ├── Dockerfile                # Docker image definition
│   ├── build-and-push.sh        # Script to build and push Docker image
│   └── myapp/                    # Django application code
└── .gitignore                    # Git ignore file
```

## Features

- **Service Account Management**: Automated creation of service accounts with appropriate permissions using gcloud CLI
- **Project Setup**: Automated project creation and configuration
- **Authentication**: Key generation and policy bindings for secure access
- **Storage Bucket**: Creation of GCS buckets for data storage
- **Terraform Backend**: State management using remote backend storage
- **Kubernetes Cluster**: Provisioning of GKE clusters with worker nodes
- **Networking Configuration**: Setup of networking and security settings
- **Artifact Registry**: Automated creation of Docker image repositories
- **Cloud Run Deployment**: End-to-end containerized application deployment
- **Infrastructure Automation**: Complete IaC workflow for reproducible deployments

## Quick Start

### Prerequisites

1. **GCP Account**: A Google Cloud Platform account with billing enabled
2. **gcloud CLI**: Install the [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
3. **Terraform**: Install [Terraform](https://www.terraform.io/downloads) (version 1.0 or later)
4. **Docker**: Install [Docker](https://www.docker.com/get-started) for containerization
5. **Basic Knowledge**: Understanding of:
   - Terraform basics
   - gcloud CLI commands
   - Kubernetes concepts
   - Docker containers

### Installation

**Installing Terraform:**

**macOS (Homebrew):**
```bash
brew install terraform
```

**Linux:**
```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update && sudo apt-get install terraform
```

**Windows:**
1. Download the Windows 64-bit ZIP file from [Terraform downloads](https://www.terraform.io/downloads)
2. Extract the ZIP file
3. Add the extracted directory to your system PATH

**Verify Installation:**
```bash
terraform version
```

### Initial Setup

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd terraform_on_gcp
   ```

2. **Authenticate with GCP**:
   ```bash
   gcloud auth login
   gcloud auth application-default login
   ```

3. **Set up GCP project and service account** (See implementation_steps.ipynb for detailed instructions)

## Implementation Steps

**All detailed implementation steps with code examples are available in the Jupyter notebook:**

📓 **[implementation_steps.ipynb](./implementation_steps.ipynb)**

The notebook contains:
- **Phase 1**: Infrastructure Setup with gcloud CLI (Tasks 1-3)
- **Phase 2**: Infrastructure as Code with Terraform (Tasks 4-12)
- **Phase 3**: Deploy Application to Cloud Run (Tasks 13-17)
- **Cleanup**: Destroy All Resources (Task 18)

Each task includes:
- Detailed descriptions
- Code snippets and commands
- Prerequisites and verification steps
- Troubleshooting tips

### Quick Reference

**Phase 1: Infrastructure Setup**
1. Containerize the application (Docker build and push)
2. Set up service account (GCP project and IAM roles)
3. Configure authentication (Service account keys)

**Phase 2: Infrastructure as Code**
4. Configure variables (`variables.tf`)
5. Configure outputs (`output.tf`)
6. Define provider (`main.tf`)
7. Initialize infrastructure (`terraform init` and `apply`)
8. Create storage bucket (GCS bucket for state)
9. Store Terraform state in backend (GCS backend)
10. Set up GKE cluster (Kubernetes cluster)
11. Deploy worker nodes (Node pool configuration)
12. Set up connection with worker nodes (kubectl configuration)

**Phase 3: Deploy Application**
13. Enable and create Artifact Registry (Docker repository)
14. Push image to Artifact Registry (Docker image migration)
15. Enable Cloud Run API (API enablement)
16. Host container on Cloud Run (Service deployment)
17. Locate the address of deployed service (Output configuration)

**Cleanup**
18. Destroy all resources (`terraform destroy`)

## Usage

### Basic Workflow

1. **Configure Variables**: Update `variables.tf` with your project-specific values
2. **Initialize Terraform**: Run `terraform init` to download providers
3. **Plan Changes**: Run `terraform plan` to preview infrastructure changes
4. **Apply Changes**: Run `terraform apply` to create infrastructure
5. **View Outputs**: Run `terraform output` to see important values (like Cloud Run URL)
6. **Destroy Resources**: Run `terraform destroy` when done (to avoid charges)

### Common Commands

```bash
# Initialize Terraform
terraform init

# Format code
terraform fmt

# Validate syntax
terraform validate

# Preview changes
terraform plan

# Apply changes
terraform apply

# View outputs
terraform output

# Destroy infrastructure
terraform destroy
```

## Configuration Files

### variables.tf
Contains all input variables with default values. Update these with your project-specific values:
- `project_id`: Your GCP project ID
- `region`: GCP region (e.g., `us-east1`)
- `state_bucket`: Unique bucket name for Terraform state
- `cluster_name`: Name for your GKE cluster
- `service_name`: Name for your Cloud Run service
- And more...

### main.tf
Contains all Terraform resource definitions:
- Provider configuration
- Backend configuration
- Storage bucket
- GKE cluster and node pool
- Artifact Registry repository
- Cloud Run service

### output.tf
Contains output definitions that expose important information:
- Project ID
- Cluster name
- Cloud Run service URL
- And more...

## Security Best Practices

- **Never commit credentials**: Add `account.json` and `*.tfvars` to `.gitignore`
- **Use least privilege**: Grant only necessary IAM roles to service accounts
- **Rotate keys regularly**: Create new service account keys periodically
- **Enable versioning**: Enable versioning on state buckets for recovery
- **Use remote backend**: Store Terraform state in GCS for team collaboration
- **Review IAM policies**: Regularly audit IAM bindings and permissions

## Troubleshooting

### Common Issues

**Permission Errors:**
- Ensure service account has required IAM roles (Editor, Storage Admin, Container Admin, Run Admin)
- Verify `account.json` file exists and is valid
- Check project ID matches your GCP project

**Bucket Name Conflicts:**
- GCS bucket names must be globally unique
- Use project ID in bucket name: `terraform-state-YOUR-PROJECT-ID`

**API Not Enabled:**
- Enable required APIs: Compute Engine, Kubernetes Engine, Storage, Artifact Registry, Cloud Run
- Use `gcloud services enable` or Terraform `google_project_service` resource

**Cluster Creation Timeout:**
- GKE cluster creation takes 5-15 minutes
- Check quotas and limits in GCP Console
- Verify billing is enabled

**Image Pull Errors:**
- Ensure Cloud Run service account has Artifact Registry reader role
- Verify image exists in Artifact Registry
- Check image path matches exactly (case-sensitive)

For detailed troubleshooting steps, see the [implementation_steps.ipynb](./implementation_steps.ipynb) notebook.

## Cleanup

### Task 18: Destroy the Resources

⚠️ **CRITICAL WARNING: DO NOT DELETE YOUR GCP PROJECT!**

**This task is about destroying Terraform-managed resources, NOT deleting your GCP project.**

- ✅ **DO**: Use `terraform destroy` to remove infrastructure resources
- ✅ **DO**: Keep your GCP project (it's free when no resources are running)
- ❌ **DON'T**: Delete the GCP project using `gcloud projects delete`
- ❌ **DON'T**: Delete the project via the GCP Console

**Why keep the project?**
- Projects are free when no resources are running
- You may need it for future work or other resources
- Deleting the project deletes ALL resources, not just Terraform-managed ones
- Project deletion is difficult to reverse and can cause data loss

---

This task involves cleaning up all the infrastructure resources created during this project. Proper cleanup is essential to avoid unnecessary charges and to maintain a clean GCP environment.

**Understanding Resource Destruction:**

When you destroy Terraform-managed infrastructure:
- Resources are deleted in the correct order (dependencies first)
- Some resources may take time to delete (e.g., GKE clusters can take 10-15 minutes)
- State files are updated to reflect deletions
- Some resources may have deletion protection enabled

**Step 1: Review resources to be destroyed**

Before destroying, review what will be deleted:

```bash
# List all resources in state
terraform state list

# Preview what will be destroyed
terraform plan -destroy

# View specific resource details
terraform state show RESOURCE_NAME
```

**Step 2: Handle deletion protection**

Some resources (like GKE clusters) may have deletion protection enabled. You need to disable it before destruction:

**Option A: Update Terraform configuration**

Add `deletion_protection = false` to your cluster configuration in `main.tf`:

```hcl
resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region
  project  = var.project_id

  # Disable deletion protection to allow cluster deletion
  deletion_protection = false

  # ... other configuration ...
}
```

Then apply the change:

```bash
terraform apply -target=google_container_cluster.primary
```

**Option B: Delete cluster directly with gcloud**

If Terraform state is unavailable, delete the cluster directly:

```bash
gcloud container clusters delete CLUSTER_NAME \
  --region=REGION \
  --project=PROJECT_ID \
  --quiet
```

**Step 3: Destroy Terraform infrastructure**

Destroy all Terraform-managed resources:

```bash
# Interactive mode (recommended for first-time cleanup)
terraform destroy

# Non-interactive mode (use with caution)
terraform destroy -auto-approve
```

**Expected output:**
```
Terraform will perform the following actions:

  # google_artifact_registry_repository.docker_repo will be destroyed
  # google_cloud_run_service.app will be destroyed
  # google_container_cluster.primary will be destroyed
  # ... (other resources)

Plan: 0 to add, 0 to change, 11 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

google_cloud_run_service.app: Destroying... [id=...]
google_cloud_run_service.app: Destruction complete after 5s
google_container_node_pool.primary_nodes: Destroying... [id=...]
google_container_node_pool.primary_nodes: Destruction complete after 10s
google_container_cluster.primary: Destroying... [id=...]
google_container_cluster.primary: Still destroying... [5m0s elapsed]
google_container_cluster.primary: Destruction complete after 8m15s
...

Destroy complete! Resources: 11 destroyed.
```

**Step 4: Verify resources are destroyed**

After destruction, verify that resources are gone:

```bash
# Check Terraform state (should be empty or minimal)
terraform state list

# Verify GKE cluster is deleted
gcloud container clusters list --project=PROJECT_ID

# Verify Cloud Run service is deleted
gcloud run services list --project=PROJECT_ID --region=REGION

# Verify Artifact Registry repository is deleted
gcloud artifacts repositories list --project=PROJECT_ID --location=REGION

# Verify storage bucket (if not deleted automatically)
gcloud storage buckets list --project=PROJECT_ID
```

**Step 5: DO NOT DELETE THE GCP PROJECT**

**CRITICAL WARNING**: 

**DO NOT DELETE YOUR GCP PROJECT!**

- **Only destroy Terraform-managed resources** using `terraform destroy`
- **Keep your GCP project** - you may need it for future work or other resources
- Deleting the project will delete **ALL** resources, including those not managed by Terraform
- Project deletion can cause data loss and is difficult to reverse
- If you delete the project, you'll need to create a new one and reconfigure everything

**What to do instead:**

1. **Destroy only Terraform resources**: Use `terraform destroy` to remove infrastructure
2. **Keep the project**: The project itself costs nothing when no resources are running
3. **Disable billing** (optional): If you want to ensure no charges, disable billing on the project instead of deleting it
4. **Verify no charges**: Check your billing dashboard to confirm no active charges

**If you absolutely must delete the project** (NOT RECOMMENDED):

This should only be done if you're certain you'll never need the project again:

```bash
# WARNING: This is irreversible after 30 days!
# Only do this if you're absolutely sure
gcloud projects delete PROJECT_ID
```

**Important Notes:**

- Project deletion can take up to 30 days to complete
- During the deletion period, the project can be restored using `gcloud projects undelete PROJECT_ID`
- After 30 days, deletion is permanent and irreversible
- All resources in the project will be deleted
- Billing will stop immediately upon deletion request
- **It's safer to just destroy resources and keep the project**

**Troubleshooting:**

**Error: "deletion_protection is enabled"**
- **Solution**: Disable deletion protection first (see Step 2)
- Update Terraform config or delete cluster directly with gcloud
- Then retry `terraform destroy`

**Error: "Bucket doesn't exist" (backend error)**
- **Solution**: If state bucket was deleted, delete resources manually with gcloud
- Or recreate the bucket: `gcloud storage buckets create gs://BUCKET_NAME --location=REGION`
- Or use local backend temporarily for cleanup

**Error: "Resource is in use"**
- **Solution**: Check for dependent resources
- Delete dependencies first (e.g., node pools before cluster)
- Use `terraform destroy -target` to delete in order

**Cluster deletion takes too long**
- **Solution**: GKE cluster deletion can take 10-15 minutes
- This is normal - be patient
- Check status: `gcloud container clusters describe CLUSTER_NAME --region=REGION`

**Best Practices:**

- Always review `terraform plan -destroy` before executing destroy
- Use interactive mode (`terraform destroy`) for safety
- Verify resources are actually deleted after destruction
- Keep backups of important Terraform state files
- Document any manual resource deletions
- Clean up unused service account keys
- Review billing to ensure no unexpected charges

## References

- [Educative Project: Manage Infrastructure Using Terraform on Google Cloud Platform](https://www.educative.io/projects/manage-infrastructure-using-terraform-on-google-cloud-platform)
- [Terraform Documentation](https://www.terraform.io/docs)
- [Google Cloud Platform Documentation](https://cloud.google.com/docs)
- [Terraform GCP Provider Documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [Google Cloud Run Documentation](https://cloud.google.com/run/docs)
- [Google Kubernetes Engine Documentation](https://cloud.google.com/kubernetes-engine/docs)
- [Artifact Registry Documentation](https://cloud.google.com/artifact-registry/docs)

## License

See [LICENSE](./LICENSE) file for details.
