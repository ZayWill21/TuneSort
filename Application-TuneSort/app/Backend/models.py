from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False) # May want to delete this and have their email as their username
    email = db.Column(db.String(120), unique=True, nullable=False)
    password = db.Column(db.String(80), nullable=False)
    
    def to_json(self):
        return {
            "id":self.id,
            "username":self.username,
            "email":self.email,
            "password":self.password,
        }

class Song(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    song_name = db.Column(db.String(80), unique=True, nullable=False)
    genre = db.Column(db.String(80), nullable=False)
    Artist = db.Column(db.String(80), nullable=False)

    def to_json(self):
        return {
            "id":self.id,
            "song_name":self.song_name,
            "genre":self.genre,
            "Artist":self.Artist,
        }
    
class Playlist(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    playlist_name = db.Column(db.String(80), nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    user = db.relationship('User', backref=db.backref('playlists', lazy=True))
    song_ids = db.Column(db.Integer, db.ForeignKey('song.id'), nullable=False)
    songs = db.relationship('Song', backref=db.backref('playlists', lazy=True))
    
    def to_json(self):
        return {
            "id":self.id,
            "playlist_name":self.playlist_name,
            "user_id":self.user_id,
            "song_ids":self.song_ids,
        }