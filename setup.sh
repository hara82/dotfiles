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

# Handle script options
case "$1" in
    --link)
        create_symlinks
        ;;
    --unlink)
        remove_symlinks
        ;;
    *)
        echo "Usage: $0 --link | --unlink"
        ;;
esac
