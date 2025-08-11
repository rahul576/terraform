# terraform
terraform repo
Environments Folders - Each environment (dev, staging, prod) has its own set of resource definitions that use common modules. Keeps environments isolated so changes in dev don’t break prod.

Modules Folder - Reusable building blocks for infrastructure. DRY (Don’t Repeat Yourself) principle — define once, use in multiple places.
       compute    -  # VM, load balancer
       storage.   -  # S3 buckets / Azure Storage / GCP buckets
       networking -  #subnets, routing tables

Global Resources - Some resources are shared across environments — like DNS zones, IAM policies, or organization-level settings.


Backend & Providers  - 
	•	backend.tf — Configures remote state storage (e.g., Azure Blob, S3 + DynamoDB, Terraform Cloud).
	•	provider.tf — Defines cloud providers and authentication.
	•	versions.tf — Locks Terraform and provider versions.


State Management.  - 
In production:
	•	One state file per environment (and sometimes per module for very large orgs).
	•	State stored remotely (Azure Storage, AWS S3, etc.).
	•	Locks enabled to prevent multiple people applying at once.

terraform.tfvars - we can create this file in dev env and keep imp login data in it(Never Commit in Git)
    subscription_id = ""
    tenant_id       = ""
    client_id       = ""
    client_secret   = ""

Note : Terraform automatically maps environment variables with the TF_VAR_ prefix to variables.
    export TF_VAR_subscription_id=""
    export TF_VAR_tenant_id=""
    export TF_VAR_client_id=""
    export TF_VAR_client_secret=""

terraform/
│
├── global/                            # Resources shared across environments
│   ├── backend/                       # Remote state storage configuration
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── networking/                    # Global VPC / networking setup
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── security/                      # Global IAM roles / security groups
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
│
├── modules/                           # Reusable building blocks
│   ├── network/                       # VPC, subnets, gateways
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── compute/                       # VM / EC2 / App Service setup
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── storage/                       # S3, Blob, EFS
│   ├── database/                      # RDS, Azure SQL, etc.
│   ├── k8s/                           # Kubernetes clusters
│   └── monitoring/                    # Logging, metrics, alerting
│
├── envs/                              # Environment-specific configurations
│   ├── dev/
│   │   ├── main.tf                    # Calls modules with dev vars
│   │   ├── variables.tf
│   │   ├── terraform.tfvars           # Dev-specific values
│   │   └── outputs.tf
│   ├── staging/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   └── outputs.tf
│   └── prod/
│       ├── main.tf
│       ├── variables.tf
│       ├── terraform.tfvars
│       └── outputs.tf
│
├── providers/                         # Provider setup (AWS, Azure, GCP)
│   ├── aws.tf
│   ├── azure.tf
│   └── gcp.tf
│
├── scripts/                           # Helper scripts for automation
│   ├── plan.sh
│   ├── apply.sh
│   └── destroy.sh
│
├── versions.tf                        # Terraform version & provider versions
├── variables.tf                       # Global variables
├── outputs.tf                         # Global outputs
└── README.md