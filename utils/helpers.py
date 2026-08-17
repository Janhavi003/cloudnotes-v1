import os
import psycopg
from psycopg.rows import dict_row

SCHEMA = """
CREATE TABLE IF NOT EXISTS notes (
    id BIGSERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    filename TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);
"""

ALLOWED_EXTENSIONS = {"txt", "md", "pdf", "png", "jpg", "jpeg", "gif"}


def get_db_connection(database_url):
    return psycopg.connect(database_url, row_factory=dict_row)


def init_db(database_url):
    conn = get_db_connection(database_url)
    try:
        conn.execute(SCHEMA)
        conn.commit()
    finally:
        conn.close()


def allowed_file(filename):
    return "." in filename and filename.rsplit(".", 1)[1].lower() in ALLOWED_EXTENSIONS
