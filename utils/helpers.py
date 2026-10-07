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


ALLOWED_EXTENSIONS = {
    "txt",
    "md",
    "pdf",
    "png",
    "jpg",
    "jpeg",
    "gif",
}


def get_db_connection(database_url):
    """Create a PostgreSQL database connection."""
    if not database_url:
        raise ValueError("DATABASE_URL is required.")

    return psycopg.connect(
        database_url,
        row_factory=dict_row,
    )


def init_db(database_url):
    """Initialize the PostgreSQL database schema."""
    conn = get_db_connection(database_url)

    try:
        conn.execute(SCHEMA)
        conn.commit()
    finally:
        conn.close()


def allowed_file(filename):
    """Return True when the uploaded file has an allowed extension."""
    return (
        "." in filename
        and filename.rsplit(".", 1)[1].lower() in ALLOWED_EXTENSIONS
    )
