import os
from pydantic import BaseSettings
from dotenv import load_dotenv

load_dotenv()

class Settings(BaseSettings):
    app_name: str = "Spotify Genre Sorter"
    spotify_client_id: str = os.getenv("SPOTIFY_CLIENT_ID", "")
    spotify_client_secret: str = os.getenv("SPOTIFY_CLIENT_SECRET", "")
    spotify_redirect_uri: str = os.getenv("SPOTIFY_REDIRECT_URI", "http://localhost:8000/callback")
    
settings = Settings()
