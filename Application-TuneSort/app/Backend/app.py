# Import necessary libraries
from flask import Flask, request, redirect, url_for, session, render_template, jsonify, abort
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
from spotipy import Spotify
from spotipy.oauth2 import SpotifyOAuth
from spotipy.cache_handler import FlaskSessionCacheHandler
from dotenv import load_dotenv
import os

# Load environment variables from .env file
load_dotenv()

app = Flask(__name__)

CORS(app) # This will enable CORS for all routes

app.config['SECRET_KEY'] = os.urandom(64)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///playlist.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

#Creates database instance
db = SQLAlchemy(app)

SCOPES='playlist-read-private'
cache_handler = FlaskSessionCacheHandler(session)

sp_oauth = SpotifyOAuth(
    client_id=os.getenv('SPOTIFY_CLIENT_ID'),
    client_secret=os.getenv('SPOTIFY_CLIENT_SECRET'),
    redirect_uri=os.getenv('SPOTIFY_REDIRECT_URI'),
    scope=SCOPES,
    cache_handler=cache_handler,
    show_dialog=True
)

#Creates spotify instance
sp = Spotify(auth_manager=sp_oauth)

#This is for opumization "With app.app_context"
with app.app_context():
    db.create_all() #Creates database tables if they do not exist

#Run the app
if __name__ == '__main__':
    #Register routes with Blueprint
    from routes import main as main_blueprint
    app.register_blueprint(main_blueprint)
    app.run(debug=True)