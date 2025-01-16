# Use the latest Ubuntu image
FROM ubuntu:latest

# Set the Maintainer
LABEL maintainer="Ritik"

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update local packages and install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    software-properties-common \
    && curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g http-server

# Create required directories and add index.html
RUN mkdir -p /usr/apps/hello-docker
COPY index.html /usr/apps/hello-docker/index.html

# Set the working directory
WORKDIR /usr/apps/hello-docker

# Expose the port for HTTP Server
EXPOSE 8080

# Command to run http-server on container start
CMD ["http-server", "-s", "-p", "8080"]
