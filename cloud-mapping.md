# CloudNotes: Local Deployment to Compute Engine Mapping

| Local deployment | Compute Engine equivalent | Why they play the same role |
|---|---|---|
| Ubuntu Linux environment under WSL2 | Compute Engine VM running Ubuntu | Both provide the Linux server environment that runs CloudNotes. |
| Terminal / shell | `gcloud compute ssh` | Both provide interactive shell access to the server. |
| Local/VM address and port 5000 | Compute Engine VM static external IP and port 5000 | Both provide the network address through which the application can be reached. |
| UFW / local open port / WSL network access | GCP VPC firewall rule allowing `tcp:5000` | Both control whether traffic can reach the application's listening port. |
| systemd service | systemd on the Compute Engine VM | Both manage the Gunicorn process, including startup and crash recovery. |
| PostgreSQL running with the Linux deployment | Cloud SQL for PostgreSQL | Both provide a database service separate from the Flask application process; Cloud SQL is the managed cloud equivalent. |
| `.env` / environment variables | Instance configuration / Secret Manager | Both keep application configuration and secrets outside the application source code. |

## Request path

The local request path is:

`browser -> host / WSL network -> OS firewall / open port -> Linux server -> Flask on 0.0.0.0:5000`

The Compute Engine version uses the same basic deployment idea, but the VM's external IP and GCP VPC firewall rule provide the cloud network access.

## Key deployment idea

The Linux deployment is the foundation for the Compute Engine deployment. A Compute Engine VM is still a Linux server, so the application process, Gunicorn, systemd, environment configuration, and application port work according to the same Linux concepts.
