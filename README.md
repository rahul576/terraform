# Terraform Infrastructure Repository

## Overview
This repository follows a **modular and environment-isolated** structure for managing infrastructure as code with Terraform.

---

## Folder Structure

### **Environments (`envs/`)**
Each environment (`dev`, `staging`, `prod`) has its own set of resource definitions that call **common modules**.  
This keeps environments isolated so changes in `dev` don’t accidentally break `prod`.

---

### **Modules (`modules/`)**
Reusable building blocks for infrastructure (**DRY** principle — define once, reuse everywhere).

- `compute/` — VM, load balancers
- `storage/` — S3, Azure Blob, GCP buckets
- `networking/` — subnets, routing tables

---

### **Global Resources (`global/`)**
Shared resources across environments, e.g.:
- DNS zones
- IAM policies
- Organization-level settings

---

### **Backend & Providers**
- `backend.tf` — Configures **remote state** (Azure Blob, S3 + DynamoDB, Terraform Cloud)
- `provider.tf` — Defines cloud providers and authentication
- `versions.tf` — Locks Terraform and provider versions

---

### **State Management**
In production:
- **One state file per environment** (and sometimes per module for very large orgs)
- **Remote state storage** (Azure Storage, AWS S3, Terraform Cloud)
- **State locking enabled** to prevent multiple people applying changes at once

---

### **terraform.tfvars**
Store environment-specific configuration (never commit this to Git):
```hcl
subscription_id = ""
tenant_id       = ""
client_id       = ""
client_secret   = ""

export TF_VAR_subscription_id=""
export TF_VAR_tenant_id=""
export TF_VAR_client_id=""
export TF_VAR_client_secret=""
```

### **hierarchy view**
```
terraform/
│
├── global/                            # Resources shared across environments
│   ├── backend/                       # Remote state storage configuration
│   ├── networking/                    # Global networking setup
│   └── security/                      # Global IAM roles / security groups
│
├── modules/                           # Reusable building blocks
│   ├── network/                       # VPC, subnets, gateways
│   ├── compute/                       # VMs, App Services
│   ├── storage/                       # Object storage
│   ├── database/                      # RDS, Azure SQL, etc.
│   ├── k8s/                           # Kubernetes clusters
│   └── monitoring/                    # Logging, metrics, alerting
│
├── envs/                              # Environment-specific configurations
│   ├── dev/
│   ├── staging/
│   └── prod/
│
├── providers/                         # Provider setup
│   ├── aws.tf
│   ├── azure.tf
│   └── gcp.tf
│
├── scripts/                           # Helper scripts
│   ├── plan.sh
│   ├── apply.sh
│   └── destroy.sh
│
├── versions.tf                        # Terraform & provider versions
├── variables.tf                       # Global variables
├── outputs.tf                         # Global outputs
└── README.md
```
### TF Deployment Yaml example
```
name: Terraform Deploy

on:
  push:
    branches:
      - main

jobs:
  terraform:
    runs-on: ubuntu-latest

    env:
      TF_VAR_subscription_id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
      TF_VAR_tenant_id:       ${{ secrets.AZURE_TENANT_ID }}
      TF_VAR_client_id:       ${{ secrets.AZURE_CLIENT_ID }}
      TF_VAR_client_secret:   ${{ secrets.AZURE_CLIENT_SECRET }}

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v3
        with:
          terraform_version: 1.6.6

      - name: Terraform Init
        run: terraform init

      - name: Terraform Plan
        run: terraform plan

      - name: Terraform Apply
        run: terraform apply -auto-approve
```
