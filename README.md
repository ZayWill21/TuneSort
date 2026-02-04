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

The application integrates seamlessly with Spotify's OAuth system to access your playlists, analyzes the musical characteristics of each track, identifies and normalizes genres, and generates newly sorted playlists based on your preferences. Built as a RESTful API, TuneSort provides a straightforward interface for playlist management and organization, making it easy to discover patterns in your music collection and create more cohesive listening experiences.

The application is designed with modern cloud-native principles and deployed on Amazon EKS (Elastic Kubernetes Service) using Kubernetes orchestration. TuneSort is fully containerized with Docker and features a complete CI/CD pipeline powered by GitHub Actions for automated testing and deployment. The technical implementation leverages Python with FastAPI, organized into a modular architecture that separates concerns across the main application for HTTP request handling, a dedicated Spotify client for API communication, a genre sorter module containing the core business logic, and a configuration module for settings management. The entire stack includes integrated observability features, ensuring reliable performance and easy troubleshooting in production environments.

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
`bash
git clone (https://github.com/ZayWill21/TuneSort.git
cd Application-tunesort

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

TuneSort employs a robust containerization strategy built on a multi-stage Docker build process that creates a lean, secure Python environment optimized for production use. This approach installs only the necessary production dependencies while implementing comprehensive security settings to protect the application and its data. The containerized application includes built-in health checks and properly configured entry points to ensure reliable operation. These Docker images are stored in Amazon Elastic Container Registry (ECR), which provides secure storage with integrated vulnerability scanning to identify potential security issues before deployment. ECR's seamless IAM integration ensures that only authorized services can access the container images, while its optimized infrastructure enables fast image retrieval during deployment and scaling operations.

The application runs on Amazon Elastic Kubernetes Service (EKS), leveraging Kubernetes orchestration to provide enterprise-grade reliability and scalability. The deployment configuration includes multiple replicas to ensure high availability, with carefully defined resource limits and requests that optimize performance while preventing resource exhaustion. Kubernetes health checks monitor the application continuously and trigger automatic recovery procedures when issues are detected. Sensitive configuration data is managed through Kubernetes secrets, keeping credentials and API keys secure. The infrastructure includes service definitions for internal communication and ingress configurations that expose the application to external traffic in a controlled manner.

TuneSort's development workflow is fully automated through a comprehensive CI/CD pipeline built with GitHub Actions. This pipeline orchestrates the entire deployment process, starting with building and testing the application to catch issues early in the development cycle. Once tests pass, the workflow builds Docker images with appropriate version tags and pushes them to Amazon ECR. The pipeline then updates the Kubernetes deployments with the new image versions and performs verification checks to confirm that the deployment completed successfully. This automation ensures consistent, reliable deployments while reducing manual effort and the potential for human error, enabling rapid iteration and continuous delivery of new features and improvements.

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
Using TuneSort is straightforward and requires just a few simple steps to begin organizing your music collection. Start by accessing the service and clicking the "Login with Spotify" button to initiate the authentication process. You'll be prompted to grant the necessary permissions that allow TuneSort to access your playlists and music library. Once authenticated, you can select any playlist from your Spotify account that you'd like to analyze and organize. The interface provides various analysis options that let you customize how your music will be sorted and categorized. After configuring your preferences and submitting the request, TuneSort processes your playlist and generates the results. You can then view detailed analysis information and access your newly created, organized playlists directly through your Spotify account.

##API Endpoints
TuneSort exposes a clean RESTful API with several core endpoints that power the application's functionality. The Login endpoint initiates the Spotify OAuth flow, securely connecting your Spotify account to the service. The Callback endpoint handles the OAuth callback process, completing the authentication handshake with Spotify's servers. The Sort Playlist endpoint is where the main functionality lives—it analyzes your selected playlist, processes the tracks through the genre identification system, and creates new organized playlists based on your specifications. Finally, the Health endpoint provides real-time service health information, allowing you to verify that the application is running properly and check system status.

## Example Use Cases
TuneSort solves several common challenges that music enthusiasts face when managing their digital collections. If you have large music libraries with hundreds or thousands of tracks, TuneSort helps you organize them into coherent, genre-based collections that make sense for different listening contexts. The application excels at discovering genre patterns within your music, revealing insights about your listening habits and helping you understand the composition of your library. You can create themed playlists for specific moods, activities, or occasions by leveraging the intelligent genre sorting capabilities. TuneSort is also invaluable for playlist cleanup, helping you identify outliers, remove duplicates, and ensure that your playlists maintain a consistent musical theme.

## Observability
TuneSort implements comprehensive observability features to ensure reliable operation and quick troubleshooting when issues arise. The application uses structured logging throughout the codebase, making it easy to search, filter, and analyze log data for debugging and auditing purposes. Performance metrics are collected continuously, tracking key indicators like response times, throughput, and resource utilization to identify bottlenecks and optimization opportunities. Request tracing capabilities allow you to follow individual requests through the entire system, from the initial API call through Spotify integration and playlist generation. Alert notifications are configured to proactively notify operators of critical issues, ensuring that problems are addressed before they impact users.

## Maintenance Procedures
Maintaining TuneSort requires regular attention to several key areas to ensure security, performance, and reliability. Regular dependency updates are essential to incorporate security patches, bug fixes, and performance improvements from the Python ecosystem and third-party libraries. Security scanning runs automatically as part of the CI/CD pipeline, identifying vulnerabilities in dependencies and container images before they reach production. Performance testing should be conducted periodically to validate that the application meets response time and throughput requirements under various load conditions. Backup procedures ensure that configuration data and any persistent state can be recovered in case of system failures. Certificate rotation must be performed regularly to maintain secure TLS connections, with automated processes handling the renewal of SSL/TLS certificates before they expire.

## Future Enhancements
The TuneSort roadmap includes several exciting features planned for future releases. A web frontend user interface will provide a more intuitive, visual way to interact with the service beyond the API. Multi-user support will enable multiple people to use the same TuneSort instance with isolated data and preferences. Advanced genre analysis powered by machine learning will improve classification accuracy and discover more nuanced musical patterns. Detailed playlist statistics will give users deeper insights into their music collections with visualizations and analytics. A recommendation engine will suggest new music based on your existing playlists and listening patterns. Batch processing capabilities will allow users to process multiple playlists simultaneously for more efficient organization. Additional music platform integrations beyond Spotify will expand TuneSort's reach to services like Apple Music, YouTube Music, and others. Finally, customizable genre mapping will let users define their own genre taxonomies and classification rules to match their personal music organization preferences.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
