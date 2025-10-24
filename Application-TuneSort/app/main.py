from fastapi import FastAPI, HTTPException, Depends, Request, status
from fastapi.responses import RedirectResponse
from .spotify_client import SpotifyClient
from .genre_sorter import GenreSorter
from .config import settings
import logging
import uvicorn
import os

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

app = FastAPI(title=settings.app_name)

# Store client in memory (in production, use a proper session store)
spotify_client = None

@app.get("/")
async def root():
    return {"message": "Spotify Genre Sorter API", "status": "running"}

@app.get("/login")
async def login():
    """Start Spotify OAuth flow"""
    global spotify_client
    spotify_client = SpotifyClient()
    auth_url = spotify_client.get_auth_url()
    return {"login_url": auth_url}

@app.get("/callback")
async def callback(code: str = None, error: str = None):
    """Handle Spotify OAuth callback"""
    global spotify_client
    
    if error:
        raise HTTPException(status_code=400, detail=f"Authentication error: {error}")
    
    if not code:
        raise HTTPException(status_code=400, detail="Missing authorization code")
    
    if not spotify_client:
        spotify_client = SpotifyClient()
    
    try:
        user = spotify_client.authenticate(code)
        return {"message": "Authentication successful", "user": user}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Authentication failed: {str(e)}")

@app.get("/playlists/{playlist_id}/sort")
async def sort_playlist(playlist_id: str, create_playlists: bool = False):
    """Sort a playlist by genre"""
    global spotify_client
    
    if not spotify_client or not hasattr(spotify_client, 'sp'):
        raise HTTPException(status_code=401, detail="Not authenticated. Please login first.")
    
    try:
        # Get playlist details
        playlist = spotify_client.sp.playlist(playlist_id)
        playlist_name = playlist['name']
        
        sorter = GenreSorter(spotify_client)
        
        if create_playlists:
            # Create separate playlists for each genre
            result = sorter.create_genre_playlists(playlist_id, playlist_name)
            return {
                "message": f"Created {len(result)} genre playlists from '{playlist_name}'",
                "playlists": result
            }
        else:
            # Just return the genre breakdown
            genre_tracks = sorter.sort_playlist_by_genre(playlist_id)
            result = {genre: len(tracks) for genre, tracks in genre_tracks.items()}
            return {
                "message": f"Sorted playlist '{playlist_name}' into {len(result)} genres",
                "genres": result
            }
    except Exception as e:
        logger.error(f"Error sorting playlist: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Error sorting playlist: {str(e)}")

if __name__ == "__main__":
    uvicorn.run("app.main:app", host="0.0.0.0", port=8000, reload=True)
