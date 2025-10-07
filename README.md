## Overview

TuneSort is an innovative application designed to bring organization and harmony to your music playlists. The app automates the process of sorting songs into playlists based on their genres, solving a common pet peeve of having playlists with mixed genres playing on shuffle. With TuneSort, users can enjoy seamless music experiences by categorizing songs into appropriate playlists automatically.

## Goals and Purpose

One of my personal pet peeves is encountering playlists with different genres of music shuffled together, disrupting the listening experience. TuneSort addresses this by allowing users to:

- Put all their favorite songs into one playlist.
- Automatically sort those songs into genre-specific playlists.
- Enjoy a well-organized music library with minimal effort.

## Key Features

- **Automated Sorting:** Analyze the metadata of songs and classify them into genre-specific playlists.
- **Dynamic User Interface:** A React-based frontend enabling users to connect to their Spotify accounts and select playlists for sorting.
- **Custom Playlists:** Automatically create new playlists for genres that don't already exist.
- **Efficient Processing:** Seamlessly process entire playlists to ensure all songs are sorted appropriately.

## Technologies Used

TuneSort leverages modern tools and technologies to deliver its functionality:

- **Terraform:** Used to provision the AWS infrastructure, ensuring scalable and reliable deployment.
- **Docker:** Containerizes the server and client applications, enabling consistent environments across development and production.
- **AWS Services:**
    - **AWS Amplify:** Hosts and manages the frontend application for seamless user access.
    - **Amazon DynamoDB:** Serves as the backend database to store and manage playlist and song metadata efficiently.
- **Python:** Powers the backend application and integrates with OpenAI APIs for genre classification.
- **OpenAI APIs:** Reads song metadata and determines the genre classification through AI-driven prompts.
- **React:** Builds the dynamic and user-friendly frontend interface.

## How It Works

1. **User Authentication:** Users log in and connect their Spotify accounts through the TuneSort interface.
2. **Playlist Selection:** Users select a playlist they wish to organize.
3. **Metadata Analysis:** The backend, powered by Python and OpenAI APIs, reads the metadata of each song to determine its genre.
4. **Playlist Creation and Sorting:**
    - If a playlist for the identified genre doesn't already exist, the system creates one.
    - The song is then moved to the appropriate playlist.
5. **Dynamic Updates:** The process continues until all songs in the selected playlist are sorted.

## Why "TuneSort"?

The name "TuneSort" reflects the app's core functionality—sorting tunes into their respective categories. It streamlines playlist management, ensuring users have genre-specific playlists without manual effort.

## Future Enhancements

- Support for additional music platforms beyond Spotify.
- Advanced customization options for sorting criteria (e.g., mood, tempo).
- Enhanced AI capabilities for more nuanced genre classification.
- Integration with AWS Lambda for serverless execution of backend processes.

---

TuneSort is designed to transform how users experience their music libraries by removing the chaos of disorganized playlists. With cutting-edge technologies like Terraform, Docker, AWS Amplify, DynamoDB, and OpenAI APIs, TuneSort ensures a seamless, efficient, and enjoyable music-sorting experience.
