#!/bin/bash
set -e

echo "Installing Flutter..."

# Download and install Flutter
wget -O flutter.tar.xz https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.0-stable.tar.xz
tar xf flutter.tar.xz
export PATH="$PATH:$PWD/flutter/bin"

echo "Flutter installed, checking version..."
flutter --version

echo "Configuring Flutter for web..."
flutter config --enable-web --no-analytics

echo "Getting dependencies..."
flutter pub get

echo "Building web app..."
flutter build web --release --web-renderer html

echo "Build complete!"