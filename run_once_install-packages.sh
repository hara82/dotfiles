#!/bin/bash

set -euo pipefail

# macOSでのみ実行
if [ "$(uname)" != "Darwin" ]; then
  echo "Not on macOS, skipping Homebrew setup."
  exit 0
fi

echo "Starting Homebrew setup..."

# Homebrewがインストールされているかチェック
if ! command -v brew &> /dev/null; then
  echo "Homebrew is not installed."
  exit 1
fi

brew bundle
echo "Installing packages from Brewfile..."
echo "Homebrew setup complete."