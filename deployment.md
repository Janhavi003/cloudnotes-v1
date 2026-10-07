# CloudNotes Deployment

## 1. Linux Server Environment

CloudNotes is deployed on Ubuntu running under WSL2.

The application is deployed as a Linux service rather than being dependent on an interactive terminal session.

The deployment uses:

- Ubuntu Linux under WSL2
- Python
- Flask
- Gunicorn
- PostgreSQL
- systemd

The application runs through Gunicorn in the deployment environment. Flask debug mode is disabled for the deployed application.

## 2. Application Server

CloudNotes is served using Gunicorn.

The application is started with:

```bash
gunicorn --bind 0.0.0.0:5000 app:app
```

Gunicorn listens on `0.0.0.0:5000`, allowing CloudNotes to receive requests through the Linux/host networking path.

The Flask development server is not used as the production application server.

## 3. Environment Configuration

CloudNotes reads configuration from environment variables.

The repository contains `.env.example` with placeholder values only.

The real environment configuration contains values such as:

```text
DATABASE_URL
SECRET_KEY
```

The real `.env` file is not committed to Git and is excluded through `.gitignore`.

Example configuration:

```env
DATABASE_URL=postgresql://cloudnotes_user:CHANGE_THIS_PASSWORD@localhost:5432/cloudnotes
SECRET_KEY=CHANGE_THIS_TO_A_RANDOM_SECRET
```

The actual deployment uses real values that are stored outside the Git repository.

The application does not use a hardcoded production secret.

## 4. PostgreSQL Database

The original SQLite database has been replaced with PostgreSQL.

CloudNotes connects to PostgreSQL using the `DATABASE_URL` environment variable.

The database is:

```text
Database: cloudnotes
User: cloudnotes_user
Host: localhost
Port: 5432
```

The application initializes the required PostgreSQL schema when the application is loaded.

PostgreSQL provides persistent storage independently of the Gunicorn application process.

## 5. Managed Service

CloudNotes is managed using a systemd service named:

```text
cloudnotes.service
```

The service runs Gunicorn in the background and is configured to:

- start automatically when the Linux environment boots;
- run independently of an interactive terminal;
- restart automatically if the application process crashes.

The service uses:

```ini
Restart=always
RestartSec=3
```

The service is enabled using:

```bash
sudo systemctl enable cloudnotes
```

It can be started with:

```bash
sudo systemctl start cloudnotes
```

Its status can be checked with:

```bash
sudo systemctl status cloudnotes
```

The service configuration uses a Linux deployment directory rather than a developer-specific Windows-mounted project path.

## 6. Crash Recovery Verification

The service's automatic recovery is verified by terminating the Gunicorn process.

The process is identified using:

```bash
sudo systemctl status cloudnotes
```

After the Gunicorn process is terminated, systemd automatically starts a replacement process because the service contains:

```ini
Restart=always
```

The recovery is verified using:

```bash
sudo systemctl status cloudnotes
```

and by confirming that CloudNotes is accessible again through the browser.

## 7. Boot Recovery Verification

The service is configured to start automatically at boot.

This can be verified with:

```bash
systemctl is-enabled cloudnotes
```

The expected result is:

```text
enabled
```

The machine can then be restarted:

```bash
sudo reboot
```

After the Linux environment is available again, the service is checked with:

```bash
sudo systemctl status cloudnotes
```

CloudNotes should be running without manually starting Gunicorn.

## 8. Network Access

CloudNotes listens on:

```text
0.0.0.0:5000
```

This allows the application to receive connections through the Linux/host networking path rather than being restricted to `127.0.0.1`.

If UFW is enabled, TCP port 5000 can be allowed with:

```bash
sudo ufw allow 5000/tcp
```

The request path is:

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

CloudNotes can be tested from the browser or with:

```bash
curl http://<SERVER-IP>:5000
```

## 9. PostgreSQL Persistence Verification

Persistence is verified by creating a note and restarting the application.

The verification process is:

1. Open CloudNotes in the browser.
2. Create a test note.
3. Confirm that the note is displayed.
4. Restart the CloudNotes service:

```bash
sudo systemctl restart cloudnotes
```

5. Confirm that the service is running:

```bash
sudo systemctl status cloudnotes
```

6. Refresh CloudNotes.
7. Confirm that the previously created note is still present.

The note remains available because CloudNotes stores the data in PostgreSQL rather than in application memory.

An additional reboot test can be performed to verify both service startup and database persistence:

```bash
sudo reboot
```

After the server returns, CloudNotes should start automatically and the previously created note should still be available.

## 10. Security

The deployment avoids committing sensitive information to the repository.

Security measures include:

- Flask debug mode is disabled.
- The production application runs through Gunicorn.
- `SECRET_KEY` is supplied through an environment variable.
- `DATABASE_URL` is supplied through an environment variable.
- The real `.env` file is excluded through `.gitignore`.
- `.env.example` contains placeholders only.
- Database passwords are not stored in application source code.
- Developer-specific filesystem paths are not required by the application configuration.

## 11. Deployment Evidence

The deployment demonstration provides evidence of:

- the Ubuntu/WSL2 Linux environment;
- CloudNotes running successfully;
- the systemd service using `systemctl status cloudnotes`;
- automatic recovery after the Gunicorn process is terminated;
- automatic service startup after reboot;
- browser or `curl` access through port 5000;
- PostgreSQL being used as the persistent database;
- a note surviving an application restart;
- the local deployment mapping to Google Compute Engine.

## 12. Compute Engine Relationship

The local deployment is designed to represent the same basic architecture that can later be deployed on Google Compute Engine.

The local Ubuntu Linux environment corresponds to an Ubuntu Compute Engine VM.

The local shell corresponds to access through:

```bash
gcloud compute ssh
```

The local server IP and port correspond to a Compute Engine VM's static external IP and the required GCP VPC firewall rule.

The local systemd service corresponds to systemd running on the Ubuntu Compute Engine VM.

The local PostgreSQL database corresponds to Cloud SQL for PostgreSQL, which provides a managed database service.

Environment variables and secrets correspond to cloud configuration mechanisms such as instance configuration and Secret Manager. Sensitive production credentials should preferably be stored in Secret Manager rather than directly in application source code.

## 13. Deployment Summary

CloudNotes has been deployed as an always-on Linux application using Gunicorn and systemd.

The deployment replaces the original SQLite storage with PostgreSQL, externalizes configuration through environment variables, exposes the application through port 5000, and provides automatic service recovery.

The deployment has also been documented in terms of its equivalent Google Compute Engine architecture, providing a foundation for moving the application to a cloud VM and managed PostgreSQL service.
