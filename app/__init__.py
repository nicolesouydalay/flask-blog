import os
from flask import Flask, render_template, send_from_directory, request
from dotenv import load_dotenv
from . import db
from werkzeug.security import generate_password_hash, check_password_hash
from app.db import get_db

load_dotenv()

app = Flask(__name__)
app.config['DATABASE'] = os.path.join(os.getcwd(), 'flask.sqlite')
db.init_app(app)

@app.route('/')
def index():
    return render_template('index.html', title="Nicole Souydalay | ", url=os.getenv("URL"), name="NICOLE")

@app.route('/health', methods = ['GET'])
def health():
    return 'Works'

@app.route('/register', methods = ['GET', 'POST'])
def register():
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')
        db = get_db()
        error = None

        if not username:
            error = 'Username is required.'
        elif not password:
            error = 'Password is required.'
        elif db.execute(
            'SELECT id FROM user WHERE username = ?', (username,)
        ).fetchone() is not None:
            error = f"User {username} is already registered."

        message = error
        if error is None:
            db.execute(
                'INSERT INTO user (username, password) VALUES (?, ?)',
                (username, generate_password_hash(password))
            )
            db.commit()
            message = f"User {username} created successfully."

        return render_template('register_template.html', title="Nicole Souydalay | ", url=os.getenv("URL"), 
            message=message), 418

    return render_template('register_template.html', title="Nicole Souydalay | ", url=os.getenv("URL"))


@app.route('/login', methods = ['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')
        db = get_db()
        error = None

        if not username:
            error = 'Username is required.'
        elif not password:
            error = 'Password is required.'
        
        if error is not None:
            return render_template('login_template.html', title="Nicole Souydalay | ", url=os.getenv("URL"), 
                message=error), 418

        user = db.execute(
            'SELECT * FROM user WHERE username = ?', (username,)
        ).fetchone()

        if user is None:
            error = 'Username does not exist.'
        elif not check_password_hash(user['password'], password):
            error = 'Incorrect password.'

        if error is None:
            return render_template('login_template.html', title="Nicole Souydalay | ", url=os.getenv("URL"), 
                message="Login successful."), 200 
        else:
            return render_template('login_template.html', title="Nicole Souydalay | ", url=os.getenv("URL"), 
                message=error), 418
    
    ## TODO: Return a login page
    return render_template('login_template.html', title="Nicole Souydalay | ", url=os.getenv("URL"))

