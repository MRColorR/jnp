# JNP - Developer's Multi-Language Docker Image

<!-- Project README scaffold: https://github.com/MRColorR/project-template -->

**Start with Java, Node.js, Python, and common development tools in one Docker image.**

[**🚀 Run the Docker image**](#getting-started) · [📚 Documentation](#documentation) · [🫶 Support](#support)

**Leave a star ⭐ if you like this project 🙂 Thank you!**

## Overview


![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/mrcolorr/jnp/build-push-images.yml?style=flat&link=https%3A%2F%2Fhub.docker.com%2Fr%2Fmrcolorrain%2Fjnp)

A robust and versatile Docker image designed for developers, featuring preinstalled Java, Node.js, Python, Docker, Kubernetes, Helm, and more. Ideal for building and testing applications in a streamlined and up-to-date environment. This image is also ready to be used as base for remote development environments, making it an excellent starting point for setting up your remote development workspace.  

<a name="quick-overview-"></a>

JNP provides a complete Docker image that integrates essential programming languages ​​and runtimes such as Java, Node.js, and Python, along with crucial development tools such as Docker, Kubernetes, and Helm. This image is a starting point for developers who need a reliable and consistent development stack across multiple projects, and for anyone who wants to get started with remote development environments.

<a name="-key-features"></a>

### Key Features

- Preinstalled Languages: Java, Node.js, Python.
- Docker & Kubernetes Ready: Includes Docker in Docker (DinD), Kubernetes (kubectl), and Helm.
- NVIDIA GPU Support: Comes with the NVIDIA Container Toolkit.
- Multi-Architecture Support: Built to run on both amd64 and arm64 architectures.
- Remote Development Ready: Optimized for setting up and using in remote development environments, making it easy to create a consistent and portable workspace.

## Getting started

<a name="getting-started-"></a>

### Prerequisites
- Ensure Docker is installed and running on your machine.

### Quick Setup Guide
- Pull the Image: Get the latest JNP Docker image from Docker Hub: `docker pull mrcolorrain/jnp:base`
- Run the Container: 
    - To use Docker in Docker (DinD) start a new container in privileged mode using: `docker run -it --rm --privileged mrcolorrain/jnp:base`
        - You can also start without privileged mode; the container will work, but the DinD service start will timeout and exit, so you will be able to use Docker only by either running it in privileged mode or by pointing Docker CLI to connect to another running Docker host, starting the container, and passing the env variable DOCKER_HOST: `docker run -it --rm -e DOCKER_HOST=mydockerhost:port mrcolorrain/jnp:base`
    - To use it with Nvidia GPU support add also the `--gpus` flag: `docker run -it --rm --gpus all --privileged mrcolorrain/jnp:base`
    - Docker startup can be controlled with the `DOCKER_AUTO_START` environment variable: `docker run -it --rm -e DOCKER_AUTO_START=false mrcolorrain/jnp:base`

## Documentation

<a name="whats-inside-"></a>

### What's Inside?

- Operating System: Ubuntu 24.04 LTS
- Languages: Java (OpenJDK 21), Node.js (LTS), Python 3
- Development Tools: Docker, Kubernetes (kubectl), Helm, Build-essential, Git
- System Utilities: curl, wget, vim, nano, htop, jq, rsync

<a name="ready-for-remote-development-"></a>

### Ready for Remote Development

This image is suitable for remote development scenarios. Whether you are using a cloud-based development environment, a remote server, or a containerized on-premises setup, JNP provides the flexibility and tools you need to power your remote workspace environment.

<a name="customization-️"></a>

### Customization

Both images are designed to be versatile, allowing for easy customization:

- Modify the Dockerfile to suit your specific development needs.
- Extend the images by adding your own tools or scripts.

<a name="need-help-or-found-an-issue-"></a>

### Need Help or Found an Issue?

- For discussions, info, and feature requests, use the [Discussion](https://github.com/MRColorR/jnp/discussions) tab.
- For issues and bug reporting, use the [Issue](https://github.com/MRColorR/jnp/issues) tab.

<a name="acknowledgments-"></a>

### Acknowledgments

This project builds upon and is inspired by other excellent open-source projects. Special thanks to:

- [NVIDIA DinD](https://github.com/ehfd/nvidia-dind) for providing the base setup for Docker in Docker (DinD) with NVIDIA GPU support.

## Contributing

Ideas, bug reports, documentation fixes and focused changes are welcome through this repository's collaboration channels.

Please include enough context to reproduce a problem or review a change.

## Support

**🫶 Support the project**

Your contributions are vital in helping to sustain the development of open-source projects and tools made freely available to everyone. If you find value in my work and wish to show your support, kindly consider making a donation.

☕ [Support me on Ko-fi](https://ko-fi.com/mrcolorrain) · 💛 [Donate with cryptocurrency](https://github.com/MRColorR/MRColorR/blob/main/SUPPORTERS.md#cryptocurrency-wallets)

Thank you for helping me keep building and sharing! 🙏 See the [supporter directory](https://github.com/MRColorR/MRColorR/blob/main/SUPPORTERS.md).

<a name="support-the-project-"></a>

If you find this project helpful, consider supporting its development by leaving a star ⭐ or contributing to the repository. Your support is greatly appreciated!

## License

<a name="hash-license"></a>

This project is licensed under the Mozilla Public License 2.0 (MPL 2.0).
