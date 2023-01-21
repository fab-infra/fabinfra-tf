# fabinfra.net infrastructure

This repository holds infrastructure definition and configuration for the **fabinfra.net** domain.

## Architecture

All resources in this repository are managed by [Terraform](https://www.terraform.io). Workloads are deployed as containers on a [Kubernetes](https://kubernetes.io) cluster using [Helm](https://helm.sh).

The main infrastructure components are:
- DNS records (`dns.tf`)
- Infrastructure management (`infra.tf`)
- Kubernetes configuration (`k8s.tf`)
- Cloud storage buckets (`storage.tf`)
- Uptime checks (`uptime.tf`)
- VPN servers (`vpn.tf`)

The main underlying provider is currently [OVH](https://www.ovh.com). Some resources are hosted or backed up on [Google Cloud Platform (GCP)](https://cloud.google.com).

## Deployment

For development and deployment, download and install [Terraform CLI](https://www.terraform.io/downloads.html) version 1.0 or higher.

Create a `terraform.tfvars` file to customize sensitive variables marked as `"toComplete"` in `terrafom.auto.tfvars`. See `variables.tf` for more information.

When done, you may execute the following commands in this repository:
```
# Download plugins and current state
terraform init

# Preview infrastructure changes
terraform plan

# Apply infrastructure changes
terraform apply
```

The Terraform state is stored in a [Terraform Cloud](https://app.terraform.io/app/fabinfra/workspaces/fabinfra-tf) workspace.
