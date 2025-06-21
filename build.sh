#!/bin/bash
# Install Flutter
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Enable Flutter Web
flutter config --enable-web

# Pre-cache dependencies
flutter precache

# Get packages
flutter pub get

# Build the web app
flutter build web
