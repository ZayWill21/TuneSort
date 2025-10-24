import spotipy
from spotipy.oauth2 import SpotifyOAuth
from .config import settings
import logging

logger = logging.getLogger(__name__)

class SpotifyClient:
    def __init__(self, client_id=None, client_secret=None, redirect_uri=None):
        self.client_id = client_id or settings.spotify_client_id
        self.client_secret = client_secret or settings.spotify_client_secret
        self.redirect_uri = redirect_uri or settings.spotify_redirect_uri
        
        if not all([self.client_id, self.client_secret, self.redirect_uri]):
            raise ValueError("Missing Spotify API credentials")
        
        self.sp = None
        self.auth_manager = SpotifyOAuth(
            client_id=self.client_id,
            client_secret=self.client_secret,
            redirect_uri=self.redirect_uri,
            scope="playlist-read-private playlist-modify-private playlist-modify-public"
        )
    
    def authenticate(self, auth_code=None):
        """Authenticate with Spotify API"""
        try:
            if auth_code:
                self.auth_manager.get_access_token(auth_code)
            
            self.sp = spotipy.Spotify(auth_manager=self.auth_manager)
            user = self.sp.current_user()
            logger.info(f"Authenticated as {user['display_name']}")
            return user
        except Exception as e:
            logger.error(f"Authentication failed: {str(e)}")
            raise
    
    def get_auth_url(self):
        """Get the authorization URL for Spotify login"""
        return self.auth_manager.get_authorize_url()
    
    def get_playlist_tracks(self, playlist_id):
        """Get all tracks from a playlist"""
        if not self.sp:
            raise ValueError("Not authenticated")
        
        results = self.sp.playlist_tracks(playlist_id)
        tracks = results['items']
        
        # Pagination handling
        while results['next']:
            results = self.sp.next(results)
            tracks.extend(results['items'])
        
        return tracks
    
    def get_track_genres(self, track):
        """Get genres for a track based on its artists"""
        if not self.sp:
            raise ValueError("Not authenticated")
        
        artist_ids = [artist['id'] for artist in track['track']['artists']]
        genres = set()
        
        # Process artists in batches of 50 (API limit)
        for i in range(0, len(artist_ids), 50):
            batch = artist_ids[i:i+50]
            artists = self.sp.artists(batch)
            
            for artist in artists['artists']:
                genres.update(artist['genres'])
        
        return list(genres)
    
    def create_playlist(self, name, description="", public=False):
        """Create a new playlist"""
        if not self.sp:
            raise ValueError("Not authenticated")
        
        user_id = self.sp.current_user()['id']
        playlist = self.sp.user_playlist_create(
            user=user_id,
            name=name,
            public=public,
            description=description
        )
        return playlist
    
    def add_tracks_to_playlist(self, playlist_id, track_uris):
        """Add tracks to a playlist"""
        if not self.sp:
            raise ValueError("Not authenticated")
        
        # Add tracks in batches of 100 (API limit)
        for i in range(0, len(track_uris), 100):
            batch = track_uris[i:i+100]
            self.sp.playlist_add_items(playlist_id, batch)
