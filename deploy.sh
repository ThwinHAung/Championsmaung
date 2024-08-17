#!/bin/bash

# Build the Flutter web application
flutter build web --release --source-maps

# Define your server details
SERVER_USER="root"
SERVER_ADDRESS="championmaung.com"
SERVER_PATH="/var/www/html/web"

# Copy the build files to the server
rsync -av --delete build/web/ $SERVER_USER@$SERVER_ADDRESS:$SERVER_PATH


echo "Deployment completed successfully."

