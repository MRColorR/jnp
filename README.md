# JNP - Developer's Multi-Language Docker Image
- Leave a star ⭐ if you like this project 🙂 thank you.

| A robust and versatile Docker image designed for developers, featuring preinstalled Java, Node.js, Python, Docker, Kubernetes, Helm, and more. Ideal for building and testing applications in a streamlined and up-to-date environment. |

## Quick Overview 🚀
JNP provides a comprehensive Docker image that integrates essential programming languages and runtimes like Java, Node.js, and Python, along with crucial development tools such as Docker, Kubernetes, and Helm. This image is tailored for developers who require a reliable and consistent development stack across various projects.

## ✨ Key Features:

- Preinstalled Languages: Java, Node.js, Python.
- Docker & Kubernetes Ready: Includes Docker in Docker (DinD), Kubernetes (kubectl), and Helm.
- NVIDIA GPU Support: Comes with the NVIDIA Container Toolkit.
- Multi-Architecture Support: Built to run on both amd64 and arm64 architectures.

## Getting Started 🚥
### Prerequisites
- Ensure Docker is installed and running on your machine.

### Quick Setup Guide
- Pull the Image: Get the latest JNP Docker image from Docker Hub: `docker pull mrcolorrain/jpn:base`
- Run the Container: 
    - To use Docker in Docker (DinD) start a new container in privileged mode using: `docker run -it --rm --privileged mrcolorrain/jpn:base`
        - You can also start without privileged mode the container will work but the DinD service start will timeout and exit so you will be able to use docker only by either running it in privileged mode or by poiting docker cli to connect to another running docker host starting the container passing the nev variable DOCKER_HOST: `docker run -it --rm -e DOCKER_HOST=mydockerhost:port mrcolorrain/jpn:base` 
    - To use it with Nvidia GPU support add also the `--gpus` flag: `docker run -it --rm --gpus all --privileged mrcolorrain/jpn:base`


## What's Inside? 📦
- Operating System: Ubuntu 24.04 LTS
- Languages: Java (OpenJDK 21), Node.js (LTS), Python 3
- Development Tools: Docker, Kubernetes (kubectl), Helm, Build-essential, Git
- System Utilities: curl, wget, vim, nano, htop, jq, rsync

## Customization 🛠️
Both images are designed to be versatile, allowing for easy customization:

- Modify the Dockerfile to suit your specific development needs.
- Extend the images by adding your own tools or scripts.

## Need Help or Found an Issue? ❓
- For discussions, info, and feature requests, use the Discussion tab.
- For issues and bug reporting, use the Issue tab.

## Support the Project 🫶
If you find this project helpful, consider supporting its development by leaving a star ⭐ or contributing to the repository. Your support is greatly appreciated!

# :hash: License
This project is licensed under the GPL 3.0.