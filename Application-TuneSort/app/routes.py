from flask import Blueprint, render_template
from app import app, db
from flask import request, jsonify
from models import User

app = Blueprint('main', __name__)

#Routes for web pages
@app.route('/')
def index():
    return render_template('login.html')

@app.route('/home')
def home():
    return render_template('home.html')

#CRUD for Users Methods
@app.route('/login', methods=['GET', 'POST'])
def login():
    try:
        username = request.form['username']
        password = request.form['password']
        en_password = encrypt_password(password)
    except Exception as e:
        return jsonify({"error":"msg request to receive username and password failed"}), 400
    try:    
        if User.query.filter_by(username=username, password=en_password):
            session['username'] = username
            return jsonify({"Success": "msg User Found"}) #*****May need to change for react*****
        else:
            return jsonify({"error":"msg User not found"}), 404 
    except Exception as e:
        return jsonify({"error":"msg Request to query failed"}), 404


def encrypt_password(password):
    # This is a very simple encryption method
    return password[::-1]

@app.route('/users', methods=['POST'])
def create_user():
    try:
        data = request.json
        new_user = User(username=data['username'], email=data['email'], password=data['password']) # May want to delete this and have their email as their username
        db.session.add(new_user)
        db.session.commit()
        return jsonify({"error": f"msg {new_user} was added successfully"}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({"error": f"msg {new_user} was not added to database"}), 500
    