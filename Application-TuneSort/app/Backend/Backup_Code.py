from flask import Blueprint, render_template, request, jsonify, session, redirect, url_for
from app import sp, sp_oauth, cache_handler
from models import User

main = Blueprint('main', __name__)

#Routes for web pages
def validate_token():
    if not sp_oauth.validate_token(cache_handler.get_cached_token()):
        auth_url = sp_oauth.get_authorize_url()
        return redirect(auth_url)
    
#User will log in with spotify 
@main.route('/',methods=['GET'])
def index():
    validate_token()
    return redirect(url_for('main.get_playlists'))
    


#Route for callback
@main.route('/callback') # This is the callback route for Spotify authentication
def callback():
    sp_oauth.get_access_token(request.args['code'])
    return redirect(url_for('main.get_playlists'))

#Get the Users playlists
@main.route('/get_playlists')
def get_playlists():
    validate_token()
    
    #Create instance of playlists
    playlists = sp.current_user_playlists()
    playlists_info = [(pl["name"], pl["external_urls"]["spotify"]) for pl in playlists["items"]]
    #playlists_json = [{"name": name, "url": url} for name, url in playlists_info]
    playlists_html = '<br>'.join([f'<a href="{url}">{name}</a>' for name, url in playlists_info])
    return playlists_html

#End User session
@main.route('/logout')
def logout():
    session.clear()
    return redirect(url_for('main.index'))
"""
#CRUD for Users Methods
@main.route('/login', methods=['GET', 'POST'])
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

@main.route('/users', methods=['POST'])
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
"""   