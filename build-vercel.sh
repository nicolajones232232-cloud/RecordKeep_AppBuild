#!/bin/bash
set -e

echo "🚀 Starting Flutter web build for Vercel..."

# Use curl instead of wget (available on Vercel)
echo "📦 Installing Flutter..."
curl -fsSL https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.0-stable.tar.xz | tar xJ
export PATH="$PATH:$PWD/flutter/bin"

# Fix git ownership issue
echo "🔧 Fixing git permissions..."
git config --global --add safe.directory /vercel/path0/flutter || true
git config --global --add safe.directory $PWD/flutter || true

# Clean pub cache to avoid conflicts
echo "🧹 Cleaning pub cache..."
flutter pub cache clean || true

# Quick setup
echo "⚙️ Configuring Flutter..."
flutter config --enable-web --no-analytics --no-cli-animations

echo "📚 Getting dependencies..."
flutter pub get --no-precompile

echo "🔨 Building web app..."
flutter build web --release --web-renderer html --no-tree-shake-icons

echo "✅ Build complete!"