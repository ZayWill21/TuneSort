# Terraform files for Tunesort Archtecture
# Author: Isaiah William
# Personal Project
/*_____________________________*/

# Pulls the image
resource "docker_image" "ubuntu" {
  name = "ubuntu:latest"
  
}

# Create a container
resource "docker_container" "TuneSort-Container"{
    image = docker_image.ubuntu.image_id
    name = "TuneSort-Container"
}