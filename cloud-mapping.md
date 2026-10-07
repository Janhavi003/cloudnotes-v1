# CloudNotes: Local Deployment to Compute Engine Mapping

| Local deployment | Compute Engine equivalent | Why they play the same role |
|---|---|---|
| Ubuntu Linux environment under WSL2 | Compute Engine VM running Ubuntu | Both provide a Linux server environment on which CloudNotes, Gunicorn, and its supporting services can run. |
| Terminal / shell | `gcloud compute ssh` | Both provide interactive command-line access to the Linux server for administration, troubleshooting, and deployment. |
| Local/VM address and port 5000 | Compute Engine VM static external IP and port 5000 | Both provide the network address through which clients can reach the CloudNotes application. |
| UFW / local open port / WSL network access | GCP VPC firewall rule allowing `tcp:5000` | Both control whether incoming network traffic is allowed to reach the application's listening port. |
| systemd service | systemd on the Compute Engine Ubuntu VM | Both manage the Gunicorn application process, including starting the service and restarting it after a failure. |
| PostgreSQL running with the Linux deployment | Cloud SQL for PostgreSQL | Both provide persistent PostgreSQL storage separate from the Flask application process; Cloud SQL provides the managed cloud equivalent. |
| `.env` / environment variables | Instance configuration / Secret Manager | Both allow configuration to remain outside application source code. For sensitive production credentials, Google Secret Manager is the preferred cloud service. |

## Request Path

### Local deployment

The local request path is:

```text
Browser
    ↓
Host / WSL network
    ↓
OS firewall / open port 5000
    ↓
Linux server
    ↓
Gunicorn on 0.0.0.0:5000
    ↓
Flask application
    ↓
PostgreSQL
```

### Compute Engine deployment

The equivalent cloud request path is:

```text
Browser
    ↓
Compute Engine static external IP
    ↓
GCP VPC firewall rule allowing tcp:5000
    ↓
Ubuntu Compute Engine VM
    ↓
Gunicorn on 0.0.0.0:5000
    ↓
Flask application
    ↓
Cloud SQL for PostgreSQL
```

## Compute Engine Mapping Details

### 1. Linux Server

The local Ubuntu WSL2 environment represents the Linux server on which CloudNotes runs.

In Google Cloud, this role is provided by an Ubuntu Compute Engine VM. The assignment specifies an `e2-medium` VM as the target Compute Engine environment.

### 2. Shell Access

The local terminal provides shell access to the Linux environment.

On Compute Engine, the equivalent operation is:

```bash
gcloud compute ssh <VM_NAME>
```

This allows an administrator to connect to the VM and perform deployment and maintenance tasks.

### 3. Network Address

The local deployment uses the Linux/VM address together with port `5000`.

On Compute Engine, the VM can be assigned a static external IP address. Clients can then reach CloudNotes using that address and the application's exposed port.

### 4. Firewall

The local deployment can use UFW or the WSL networking configuration to allow traffic to port `5000`.

Compute Engine uses GCP VPC firewall rules to control incoming traffic. A rule allowing `tcp:5000` would provide the corresponding network access.

### 5. Application Service

The local deployment uses systemd to manage Gunicorn.

An Ubuntu Compute Engine VM can use the same systemd configuration. Therefore, the service can continue to start at boot and restart automatically after a process failure.

### 6. Database

The local deployment uses PostgreSQL running with the Linux environment.

The cloud equivalent is Cloud SQL for PostgreSQL. Cloud SQL provides managed PostgreSQL infrastructure, reducing the need to manually maintain the database server.

### 7. Configuration and Secrets

The local deployment reads configuration such as `DATABASE_URL` and `SECRET_KEY` from environment variables.

In a cloud deployment, non-sensitive configuration can be supplied through instance configuration or environment variables. Sensitive credentials should preferably be stored in Google Secret Manager rather than committed to source code.

## Key Deployment Concept

The local Linux deployment is the foundation for the Compute Engine deployment.

A Compute Engine VM is still a Linux server, so the same core concepts apply:

- Linux filesystem and permissions
- Python environment
- Flask application
- Gunicorn application server
- systemd service management
- environment-based configuration
- network ports and firewall rules
- PostgreSQL persistence

The main difference is that Google Cloud provides the VM networking and managed database infrastructure, while the local deployment provides those components through the WSL2/Linux environment.

This makes the local deployment a practical representation of the architecture that can later be moved to Compute Engine.
