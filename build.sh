#!/bin/bash
set -e

echo "🚀 Starting Flutter web build..."

# Download and install Flutter (faster approach)
echo "📦 Installing Flutter..."
wget -q -O flutter.tar.xz https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.0-stable.tar.xz
tar xf flutter.tar.xz
export PATH="$PATH:$PWD/flutter/bin"

# Quick setup
echo "⚙️ Configuring Flutter..."
flutter config --enable-web --no-analytics --no-cli-animations

echo "📚 Getting dependencies..."
flutter pub get --no-precompile

echo "🔨 Building web app..."
flutter build web --release --web-renderer html --no-tree-shake-icons

echo "✅ Build complete!"