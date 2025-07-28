import os
from flask import Flask, render_template, request, redirect, url_for
import psycopg2

app = Flask(__name__)

# Database connection details from environment variables
DB_HOST = os.environ.get('DB_HOST', 'localhost') # 'db' for docker-compose, 'localhost' for local direct run
DB_NAME = os.environ.get('DB_NAME', 'mydatabase')
DB_USER = os.environ.get('DB_USER', 'myuser')
DB_PASSWORD = os.environ.get('DB_PASSWORD', 'mypassword')

def get_db_connection():
    """Establishes and returns a database connection."""
    conn = psycopg2.connect(
        host=DB_HOST,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD
    )
    return conn

@app.route('/')
def index():
    """Renders the home page, displaying existing messages."""
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute('SELECT message FROM messages ORDER BY id DESC;')
    messages = cur.fetchall()
    cur.close()
    conn.close()
    return render_template('index.html', messages=messages)

@app.route('/add_message', methods=('POST',))
def add_message():
    """Handles adding a new message to the database."""
    message = request.form['message']
    if not message:
        return redirect(url_for('index')) # Simple validation: don't add empty messages

    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute('INSERT INTO messages (message) VALUES (%s)', (message,))
    conn.commit()
    cur.close()
    conn.close()
    return redirect(url_for('index'))

if __name__ == '__main__':
    # Initialize database table on startup if it doesn't exist
    conn = None
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute('''
            CREATE TABLE IF NOT EXISTS messages (
                id SERIAL PRIMARY KEY,
                message TEXT NOT NULL
            );
        ''')
        conn.commit()
        print("Database table 'messages' checked/created successfully.")
    except Exception as e:
        print(f"Error initializing database: {e}")
    finally:
        if cur:
            cur.close()
        if conn:
            conn.close()

    app.run(host='0.0.0.0', port=5000)