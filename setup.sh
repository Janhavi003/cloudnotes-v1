#!/usr/bin/env bash
set -euo pipefail

# CloudNotes Linux deployment setup for the WSL/Ubuntu environment.
# Run this script from the CloudNotes repository root.

sudo apt update
sudo apt install -y python3 python3-pip python3-venv git postgresql postgresql-contrib

python3 -m venv venv
source venv/bin/activate

python -m pip install --upgrade pip
python -m pip install -r requirements.txt

echo
echo "PostgreSQL service:"
sudo systemctl enable postgresql
sudo systemctl start postgresql

echo
echo "Create the CloudNotes database and user manually if they do not already exist:"
echo "  sudo -u postgres psql"
echo "  CREATE USER cloudnotes_user WITH PASSWORD 'YOUR_PASSWORD';"
echo "  CREATE DATABASE cloudnotes OWNER cloudnotes_user;"
echo "  \q"

if [ ! -f .env ]; then
    cp .env.example .env
    echo
    echo ".env was created from .env.example."
    echo "Edit .env and set DATABASE_URL and SECRET_KEY before starting CloudNotes."
fi

echo
echo "Next:"
echo "1. Edit .env with the real PostgreSQL password."
echo "2. Copy cloudnotes.service to /etc/systemd/system/cloudnotes.service."
echo "3. Run: sudo systemctl daemon-reload"
echo "4. Run: sudo systemctl enable --now cloudnotes"
echo "5. Check: sudo systemctl status cloudnotes"
