import logging
from collections import defaultdict

logger = logging.getLogger(__name__)

class GenreSorter:
    def __init__(self, spotify_client):
        self.spotify_client = spotify_client
    
    def sort_playlist_by_genre(self, playlist_id):
        """Sort a playlist's tracks by genre"""
        logger.info(f"Sorting playlist {playlist_id} by genre")
        
        # Get all tracks from the playlist
        tracks = self.spotify_client.get_playlist_tracks(playlist_id)
        logger.info(f"Found {len(tracks)} tracks in playlist")
        
        # Group tracks by genre
        genre_tracks = defaultdict(list)
        
        for item in tracks:
            if not item['track']:
                continue
                
            track = item['track']
            genres = self.spotify_client.get_track_genres(item)
            
            # If no genres found, put in "Unknown" category
            if not genres:
                genre_tracks["Unknown"].append(track)
                continue
            
            # Use the first genre as the primary genre
            primary_genre = self._normalize_genre(genres[0])
            genre_tracks[primary_genre].append(track)
        
        logger.info(f"Sorted into {len(genre_tracks)} genres")
        return genre_tracks
    
    def create_genre_playlists(self, playlist_id, original_playlist_name):
        """Create separate playlists for each genre"""
        genre_tracks = self.sort_playlist_by_genre(playlist_id)
        created_playlists = {}
        
        for genre, tracks in genre_tracks.items():
            if not tracks:
                continue
                
            # Create a new playlist for this genre
            playlist_name = f"{original_playlist_name} - {genre}"
            playlist = self.spotify_client.create_playlist(
                name=playlist_name,
                description=f"Tracks from {original_playlist_name} in the {genre} genre"
            )
            
            # Add tracks to the playlist
            track_uris = [track['uri'] for track in tracks]
            self.spotify_client.add_tracks_to_playlist(playlist['id'], track_uris)
            
            created_playlists[genre] = {
                'id': playlist['id'],
                'name': playlist_name,
                'track_count': len(tracks)
            }
            
            logger.info(f"Created playlist '{playlist_name}' with {len(tracks)} tracks")
        
        return created_playlists
    
    def _normalize_genre(self, genre):
        """Normalize genre names for better grouping"""
        # Map similar genres to a common name
        genre_mapping = {
            'hip hop': 'Hip-Hop',
            'rap': 'Hip-Hop',
            'r&b': 'R&B',
            'rock': 'Rock',
            'alternative rock': 'Rock',
            'indie rock': 'Indie',
            'indie': 'Indie',
            'pop': 'Pop',
            'dance pop': 'Pop',
            'edm': 'Electronic',
            'electronic': 'Electronic',
            'house': 'Electronic',
            'techno': 'Electronic',
            'classical': 'Classical',
            'jazz': 'Jazz',
            'metal': 'Metal',
            'country': 'Country',
            'folk': 'Folk',
            'reggae': 'Reggae',
            'soul': 'Soul',
            'blues': 'Blues',
            'punk': 'Punk',
        }
        
        genre_lower = genre.lower()
        
        for key, value in genre_mapping.items():
            if key in genre_lower:
                return value
        
        # Capitalize the first letter of each word for unknown genres
        return ' '.join(word.capitalize() for word in genre.split())
