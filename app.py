from flask import Flask, render_template, send_from_directory
from api.routes import api_bp
from utils.helpers import init_db
from dotenv import load_dotenv
import os

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
UPLOAD_FOLDER = os.path.join(BASE_DIR, "uploads")

# Load environment variables from .env
load_dotenv(os.path.join(BASE_DIR, ".env"))

DATABASE_URL = os.getenv("DATABASE_URL")
if not DATABASE_URL:
    raise RuntimeError(
        "DATABASE_URL is not set. Create a .env file from .env.example."
    )

SECRET_KEY = os.getenv("SECRET_KEY")
if not SECRET_KEY:
    raise RuntimeError(
        "SECRET_KEY is not set. Add it to your environment configuration."
    )

app = Flask(__name__)

app.config["UPLOAD_FOLDER"] = UPLOAD_FOLDER
app.config["DATABASE_URL"] = DATABASE_URL
app.config["SECRET_KEY"] = SECRET_KEY
app.config["MAX_CONTENT_LENGTH"] = 5 * 1024 * 1024

app.register_blueprint(api_bp, url_prefix="/api")

# Initialize the PostgreSQL schema when the application
# is imported by Gunicorn.
init_db(DATABASE_URL)

# Ensure the upload directory exists.
os.makedirs(UPLOAD_FOLDER, exist_ok=True)


@app.route("/")
def home():
    return render_template("index.html")


@app.route("/notes")
def notes_page():
    return render_template("notes.html")


@app.route("/uploads/<path:filename>")
def uploaded_file(filename):
    return send_from_directory(
        app.config["UPLOAD_FOLDER"],
        filename
    )


if __name__ == "__main__":
    # Development/local execution only.
    # Production deployment uses Gunicorn.
    app.run(
        host="0.0.0.0",
        port=5000,
        debug=False
    )
