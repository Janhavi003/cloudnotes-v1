# CloudNotes Full Terraform Infrastructure

This configuration assembles CloudNotes as five reusable Terraform modules:

- `network` — VPC, web/app/db subnets, and application firewall
- `compute` — CloudNotes application VM
- `database` — private Cloud SQL PostgreSQL instance
- `storage` — Cloud Storage assets bucket
- `iam` — application service account and least-privilege storage role

The root module wires outputs to inputs so Terraform can infer dependencies.

## Local validation

From `infra/`:

```bash
terraform fmt -recursive
terraform init
terraform validate
terraform plan
```

For this capstone, **stop after `terraform plan`**. Do not run `terraform apply`.

This configuration uses concrete Google Cloud resource types rather than `null_resource`, so a plan is meaningful for the actual GCP infrastructure. A real `terraform plan` requires valid Google provider authentication and an accessible GCP project; no resources are created by `plan`.

## Structure

```text
infra/
├── providers.tf
├── variables.tf
├── main.tf
├── outputs.tf
├── terraform.tfvars.example
└── modules/
    ├── network/
    ├── compute/
    ├── database/
    ├── storage/
    └── iam/
```
