from spotify import SpotifyBase
from flask import Flask, request, redirect, url_for, session
from flask import render_template


app = Flask(__name__)

@app.route('/')
def index():
    return render_template('login.html')


#This function will collect the information need to log into the website.
@app.route('/login', methods=['GET', 'POST'])
def login():
    username = request.form['username']
    password = request.form['password']
    en_password = encrypt_password(password)
    return redirect(url_for('home'))

def encrypt_password(password):
    # This is a very simple encryption method
    return password[::-1]

@app.route('/home')
def home():
    return render_template('home.html')