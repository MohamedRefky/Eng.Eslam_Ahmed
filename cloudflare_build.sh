#!/bin/bash
set -e

# Install Flutter if not already in PATH
if ! command -v flutter &> /dev/null; then
  echo ">>> Flutter not found. Cloning Flutter stable..."
  git clone https://github.com/flutter/flutter.git --depth 1 -b stable "$HOME/flutter"
  export PATH="$PATH:$HOME/flutter/bin"
fi

echo ">>> Flutter version:"
flutter --version

echo ">>> Getting dependencies..."
flutter pub get

echo ">>> Building Web..."
flutter build web --release --no-tree-shake-icons --base-href "/"

echo ">>> Build completed successfully in build/web!"
