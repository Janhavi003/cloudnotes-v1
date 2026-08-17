from flask import Blueprint, jsonify, request, current_app
from werkzeug.utils import secure_filename
from utils.helpers import get_db_connection, allowed_file
import os

api_bp = Blueprint("api", __name__)


@api_bp.route("/notes", methods=["GET"])
def get_notes():
    conn = get_db_connection(current_app.config["DATABASE_URL"])
    try:
        notes = conn.execute(
            "SELECT id, title, body, filename, created_at "
            "FROM notes ORDER BY created_at DESC"
        ).fetchall()
        return jsonify([dict(note) for note in notes])
    finally:
        conn.close()


@api_bp.route("/notes", methods=["POST"])
def create_note():
    title = request.form.get("title", "Untitled Note")
    body = request.form.get("body", "")
    filename = None

    uploaded_file = request.files.get("attachment")
    if uploaded_file and allowed_file(uploaded_file.filename):
        filename = secure_filename(uploaded_file.filename)
        destination = os.path.join(
            current_app.config["UPLOAD_FOLDER"], filename
        )
        uploaded_file.save(destination)

    conn = get_db_connection(current_app.config["DATABASE_URL"])
    try:
        cursor = conn.execute(
            "INSERT INTO notes (title, body, filename) "
            "VALUES (%s, %s, %s) RETURNING id",
            (title, body, filename),
        )
        note_id = cursor.fetchone()["id"]
        conn.commit()
        return jsonify(
            {
                "id": note_id,
                "title": title,
                "body": body,
                "filename": filename,
            }
        ), 201
    except Exception:
        conn.rollback()
        raise
    finally:
        conn.close()


@api_bp.route("/notes/<int:note_id>", methods=["GET"])
def get_note(note_id):
    conn = get_db_connection(current_app.config["DATABASE_URL"])
    try:
        note = conn.execute(
            "SELECT id, title, body, filename, created_at "
            "FROM notes WHERE id = %s",
            (note_id,),
        ).fetchone()
        if note is None:
            return jsonify({"error": "Note not found"}), 404
        return jsonify(dict(note))
    finally:
        conn.close()


@api_bp.route("/notes/<int:note_id>", methods=["DELETE"])
def delete_note(note_id):
    conn = get_db_connection(current_app.config["DATABASE_URL"])
    try:
        cursor = conn.execute(
            "DELETE FROM notes WHERE id = %s",
            (note_id,),
        )
        conn.commit()
        deleted = cursor.rowcount
        if deleted == 0:
            return jsonify({"error": "Note not found"}), 404
        return jsonify({"message": "Note deleted"}), 200
    except Exception:
        conn.rollback()
        raise
    finally:
        conn.close()
