# CloudNotes Deployment

## 1. Linux server environment

CloudNotes is deployed on Ubuntu running under WSL2 on the local computer.

The repository is located at:

`/mnt/e/Kalvium/semester-7/cloudnotes-v1`

The application runs with Python and Gunicorn rather than Flask's development server.

## 2. Application server

Gunicorn runs the Flask application using:

`gunicorn --bind 0.0.0.0:5000 app:app`

The application binds to `0.0.0.0:5000` so it can receive requests through the Linux/host networking path.

## 3. Environment configuration

Application configuration is stored in environment variables.

The repository contains `.env.example` with placeholders. The real `.env` file contains the PostgreSQL connection string and Flask secret and must not be committed.

## 4. PostgreSQL

SQLite was replaced with PostgreSQL.

CloudNotes reads:

`DATABASE_URL=postgresql://cloudnotes_user:PASSWORD@localhost:5432/cloudnotes`

The application creates the `notes` table in PostgreSQL when the application starts.

The important persistence test is:

1. Create a note in CloudNotes.
2. Restart the CloudNotes service.
3. Open CloudNotes again.
4. Confirm that the note is still present.

This proves the note is stored in PostgreSQL independently of the application process.

## 5. Managed service

CloudNotes is managed by systemd using `cloudnotes.service`.

The service:

- starts automatically when the Linux environment boots;
- runs Gunicorn in the background;
- restarts automatically after a process crash;
- is not tied to an interactive terminal session.

The key configuration is:

`Restart=always`

and:

`WantedBy=multi-user.target`

## 6. Network access

The request path is:

`browser -> host / WSL network -> OS firewall / open port -> Linux server -> Flask on 0.0.0.0:5000`

For a Linux firewall using UFW, TCP port 5000 can be allowed with:

`sudo ufw allow 5000/tcp`

For WSL, Windows/WSL networking and the selected access method must also allow the host browser to reach port 5000.

## 7. Evidence to capture

The deployment evidence should show:

- the Ubuntu/WSL Linux environment;
- CloudNotes running;
- `systemctl status cloudnotes`;
- automatic restart after killing the Gunicorn process;
- CloudNotes returning after a reboot;
- browser or curl access through port 5000;
- a note surviving an application restart;
- the local-to-Compute-Engine mapping.

## 8. Security

Real passwords, keys, and secrets are not committed to Git.

`.env.example` contains placeholders only.

## 9. Deployment summary

The deployment changes CloudNotes from a process manually started on a laptop into an always-on Linux service with PostgreSQL persistence, network access through port 5000, and a documented mapping to Google Compute Engine.
