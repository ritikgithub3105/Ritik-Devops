# Use the lightweight Alpine image
FROM alpine:latest

# Add maintainer information
LABEL maintainer="Ritik ritik315cool@gmail.com"

# Update and install Node.js
RUN apk update && apk add --no-cache nodejs npm

# Copy the current directory into the container at /app
COPY . /app

# Set the working directory to /app
WORKDIR /app

# Define the default command to run the app
CMD ["node", "index.js"]
