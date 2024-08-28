#!/bin/bash

set -e # Exit immediately if a command exits with a non-zero status

DOTFILES_DIR=~/dotfiles
CONFIG_DIR=~/.config

# Function to create symbolic links
create_symlinks() {
    echo "Creating symbolic links..."

    # Create symbolic    
    # Ensure the .config/wezterm directory exists
    mkdir -p "$CONFIG_DIR/wezterm"
    ln -sf "$DOTFILES_DIR/wezterm/wezterm.lua" "$CONFIG_DIR/wezterm/wezterm.lua"
    echo "Created link: $CONFIG_DIR/wezterm/wezterm.lua -> $DOTFILES_DIR/wezterm/wezterm.lua"

    mkdir -p "$CONFIG_DIR/sheldon"
    ln -sf "$DOTFILES_DIR/sheldon/plugins.toml" "$CONFIG_DIR/sheldon/plugins.toml"
    echo "Created link: $CONFIG_DIR/sheldon/plugins.toml -> $DOTFILES_DIR/sheldon/plugins.toml"

    ln -sf "$DOTFILES_DIR/starship/starship.toml" "$CONFIG_DIR/starship.toml"
    echo "Created link: $CONFIG_DIR/starship.toml -> $DOTFILES_DIR/starship/starship.toml"

    ln -sf "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
    echo "Created link: $HOME/.zshrc -> $DOTFILES_DIR/zsh/.zshrc"

    ln -sf "$DOTFILES_DIR/vim/.vimrc" "$HOME/.vimrc"
    echo "Created link: $HOME/.vimrc -> $DOTFILES_DIR/vim/.vimrc"

    ln -sf "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
    echo "Created link: $HOME/.gitconfig -> $DOTFILES_DIR/git/.gitconfig"

    echo "All symbolic links have been created."
}

# Function to remove symbolic links
remove_symlinks() {
    echo "Removing symbolic links..."

    # Remove symbolic links for each file
    if [ -L "$CONFIG_DIR/wezterm/wezterm.lua" ]; then
        unlink "$CONFIG_DIR/wezterm/wezterm.lua"
        echo "Removed link: $CONFIG_DIR/wezterm/wezterm.lua"
    fi

    if [ -L "$CONFIG_DIR/sheldon/plugins.toml" ]; then
        unlink "$CONFIG_DIR/sheldon/plugins.toml"
        echo "Removed link: $CONFIG_DIR/sheldon/plugins.toml"
    fi

    if [ -L "$CONFIG_DIR/starship.toml" ]; then
        unlink "$CONFIG_DIR/starship.toml"
        echo "Removed link: $CONFIG_DIR/starship.toml"
    fi

    if [ -L "$HOME/.zshrc" ]; then
        unlink "$HOME/.zshrc"
        echo "Removed link: $HOME/.zshrc"
    fi

    if [ -L "$HOME/.vimrc" ]; then
        unlink "$HOME/.vimrc"
        echo "Removed link: $HOME/.vimrc"
    fi

    if [ -L "$HOME/.gitconfig" ]; then
        unlink "$HOME/.gitconfig"
        echo "Removed link: $HOME/.gitconfig"
    fi

    echo "All symbolic links have been removed."
}

# Function to install Homebrew on Linux
setup_homebrew() {
    echo "Setting up Homebrew..."

    # Check if Homebrew is already installed
    if command -v brew &> /dev/null; then
        echo "Homebrew is already installed."
    else
        echo "Homebrew is not installed. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # Add Homebrew to the PATH
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    echo "Homebrew setup is complete."
}

# Function to install programs using Brewfile
install_brewfile_packages() {
    echo "Installing packages from Brewfile..."

    if [ -f "$DOTFILES_DIR/homebrew/Brewfile" ]; then
        brew bundle --file="$DOTFILES_DIR/homebrew/Brewfile"
        echo "Brewfile packages installation is complete."
    else
        echo "Brewfile not found at $DOTFILES_DIR/homebrew/Brewfile."
        exit 1
    fi
}

# Handle script options
case "$1" in
    --install-homebrew)
        setup_homebrew
        ;;
    --install-packages)
        install_brewfile_packages
        ;;
    --link)
        create_symlinks
        ;;
    --unlink)
        remove_symlinks
        ;;
    --all)
        remove_symlinks
        create_symlinks
        setup_homebrew
        install_brewfile_packages
        ;;
    *)
        echo "Usage: $0 --link | --unlink | --install-homebrew | --install-packages | --all"
        ;;
esac
