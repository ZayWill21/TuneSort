from spotify import SpotifyBase
from flask import Flask, request, redirect, url_for, session
from flask import render_template
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS


app = Flask(__name__)

CORS(app) # This will enable CORS for all routes

db = SQLAlchemy(app)
import routes

#This is for opumization "With app.app_context"
with app.app_context():
    db.create_all()

if __name__ == '__main__':
    app.run(debug=True)