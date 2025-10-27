# Spotify Genre Sorter

A cloud-native microservice that organizes Spotify playlists by automatically categorizing tracks by genre.

## Project Overview

Spotify Genre Sorter helps music enthusiasts organize their music collections by analyzing tracks in Spotify playlists and categorizing them by genre. This tool leverages artist metadata from Spotify to create new, organized playlists grouped by musical genre.

Built as a complete modern application, this project demonstrates:

- Third-party API integration (Spotify Web API)
- Containerization best practices
- Cloud-native deployment on AWS EKS
- Scalable microservice architecture

The service can process playlists of any size while maintaining performance through horizontal scaling capabilities provided by Kubernetes orchestration.

## System Architecture

### Component Overview
- API Layer: FastAPI-based REST API for handling user requests
- Spotify Integration Module: Manages OAuth authentication and Spotify Web API communication
- Genre Analysis Engine: Core business logic for genre identification and processing
- Infrastructure Layer: AWS cloud infrastructure (EKS, ECR, IAM, networking)

### Data Flow
#### Authentication Flow
User initiates authentication → Spotify OAuth consent → Authorization code → Access token

#### Playlist Processing Flow
User submits playlist → System retrieves tracks → Identifies artists and genres → Categorizes and groups tracks → Creates new playlists

#### Deployment Flow
Code changes pushed to GitHub → GitHub Actions builds Docker image → Image pushed to ECR → Kubernetes deployment updated

## Key Features

### Core Functionality
- Spotify OAuth Integration
- Playlist Analysis
- Genre Identification and Normalization
- Automatic Playlist Generation
- RESTful API

### Technical Features
- Containerized Application (Docker)
- Kubernetes Deployment (Amazon EKS)
- CI/CD Pipeline (GitHub Actions)
- Cloud-Native Design
- Integrated Observability

## Implementation Details

### Application Structure
The application uses Python with FastAPI and is organized into modules:

- Main Application: HTTP request handling
- Spotify Client: API communication
- Genre Sorter: Business logic
- Configuration: Settings management

### Key Algorithms
The genre sorting algorithm:

1. Retrieves tracks from specified playlist
2. Identifies artists for each track
3. Retrieves artist genres from Spotify
4. Normalizes genre names
5. Selects primary genre for each track
6. Groups tracks by genre
7. Creates new playlists as requested

### Technology Stack
- Backend: Python 3.9, FastAPI, Spotipy
- Containerization: Docker
- Orchestration: Kubernetes on Amazon EKS
- CI/CD: GitHub Actions
- Registry: Amazon ECR
- Cloud Provider: AWS
- Monitoring: Prometheus, Grafana

## Deployment Workflow

### Local Development Setup

1. Clone the repository:
```bash
git clone https://github.com/yourusername/spotify-genre-sorter.git
cd spotify-genre-sorter

Create a virtual environment:
    
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

    
Install dependencies:
    
pip install -r requirements.txt

    
Create a .env file with your Spotify credentials:
    
SPOTIFY_CLIENT_ID=your_client_id
SPOTIFY_CLIENT_SECRET=your_client_secret
SPOTIFY_REDIRECT_URI=http://localhost:8000/callback

    
Run the application locally:
    
uvicorn app.main:app --reload

Access the API at http://localhost:8000


## Containerization

The application uses a multi-stage Docker build process that:

- Creates a lean Python environment
- Installs production dependencies
- Configures security settings
- Sets up health checks and entry points

### Container Registry
The Docker image is stored in Amazon ECR, providing:

- Secure storage for container images
- Vulnerability scanning
- IAM integration
- Fast image retrieval

### Kubernetes Deployment
The application runs on Amazon EKS with:

- Multiple replicas for high availability
- Resource limits and requests
- Health checks for automatic recovery
- Secrets management
- Service and ingress configurations

## CI/CD Pipeline

The GitHub Actions workflow automates:

- Building and testing the application
- Building and tagging Docker images
- Pushing images to ECR
- Updating Kubernetes deployments
- Verifying successful deployment

## Challenges and Solutions

### ECR Permission Issues
**Challenge:** Access denied errors when pushing images to ECR during CI/CD.

**Solution:**
- Created dedicated IAM role for GitHub Actions
- Implemented OIDC authentication
- Configured repository policies
- Enhanced error logging

### CrashLoopBackOff Pod Errors
**Challenge:** Pods crashing immediately after deployment.

**Solution:**
- Enhanced logging configuration
- Identified missing environment variables
- Implemented proper health probes
- Added init containers

### EKS Node Group IAM Permissions
**Challenge:** "ImagePullBackOff" errors when nodes couldn't access ECR.

**Solution:**
- Updated node instance role permissions
- Created Kubernetes secrets for ECR authentication
- Added imagePullSecrets to deployments
- Implemented node bootstrap configuration

### Network Connectivity Issues
**Challenge:** Connectivity problems with Spotify API from EKS.

**Solution:**
- Updated security groups
- Configured proper DNS resolution
- Implemented network policies
- Set up VPC endpoints
- Added retry logic

    
## User Guide

### Getting Started
1. Access the service and click "Login with Spotify"
2. Grant the requested permissions
3. Select a playlist to analyze
4. Choose analysis options
5. Submit the request
6. View results and access new playlists

### API Endpoints
- Login: Initiates Spotify OAuth
- Callback: Handles OAuth callback
- Sort Playlist: Analyzes and creates playlists
- Health: Service health information

### Example Use Cases
- Organizing large music libraries
- Discovering genre patterns
- Creating themed playlists
- Playlist cleanup

## Monitoring and Maintenance

### Observability
- Structured logging
- Performance metrics
- Request tracing
- Alert notifications

### Maintenance Procedures
- Regular dependency updates
- Security scanning
- Performance testing
- Backup procedures
- Certificate rotation

## Future Enhancements
- Web frontend user interface
- Multi-user support
- Advanced genre analysis with machine learning
- Detailed playlist statistics
- Recommendation engine
- Batch processing capabilities
- Additional music platform integrations
- Customizable genre mapping

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
