#!/bin/bash

set -euo pipefail # Exit immediately if a command exits with a non-zero status

readonly DOTFILES_DIR="${HOME}/dotfiles"
readonly CONFIG_DIR="${HOME}/.config"

# Path to the shell configuration file
readonly SHELL_PATH_FILE="${HOME}/dotfiles/zsh/zsh_settings/path.zsh"

# Function to create symbolic links
create_symlinks() {
    echo "Creating symbolic links..."

    # Create symbolic
    # Ensure the .config/wezterm directory exists
    mkdir -p "${CONFIG_DIR}/wezterm"
    ln -sf "${DOTFILES_DIR}/wezterm/wezterm.lua" "${CONFIG_DIR}/wezterm/wezterm.lua"
    echo "Created link: ${CONFIG_DIR}/wezterm/wezterm.lua -> ${DOTFILES_DIR}/wezterm/wezterm.lua"

    mkdir -p "${CONFIG_DIR}/sheldon"
    ln -sf "${DOTFILES_DIR}/sheldon/plugins.toml" "${CONFIG_DIR}/sheldon/plugins.toml"
    echo "Created link: ${CONFIG_DIR}/sheldon/plugins.toml -> ${DOTFILES_DIR}/sheldon/plugins.toml"

    ln -sf "${DOTFILES_DIR}/starship/starship.toml" "${CONFIG_DIR}/starship.toml"
    echo "Created link: ${CONFIG_DIR}/starship.toml -> ${DOTFILES_DIR}/starship/starship.toml"

    ln -sf "${DOTFILES_DIR}/zsh/.zshrc" "${HOME}/.zshrc"
    echo "Created link: ${HOME}/.zshrc -> ${DOTFILES_DIR}/zsh/.zshrc"

    ln -sf "${DOTFILES_DIR}/vim/.vimrc" "${HOME}/.vimrc"
    echo "Created link: ${HOME}/.vimrc -> ${DOTFILES_DIR}/vim/.vimrc"

    ln -sf "${DOTFILES_DIR}/git/.gitconfig" "${HOME}/.gitconfig"
    echo "Created link: ${HOME}/.gitconfig -> ${DOTFILES_DIR}/git/.gitconfig"

    echo "All symbolic links have been created."
}

# Function to remove symbolic links
remove_symlinks() {
    echo "Removing symbolic links..."

    # Remove symbolic links for each file
    if [[ -L "${CONFIG_DIR}/wezterm/wezterm.lua" ]]; then
        unlink "${CONFIG_DIR}/wezterm/wezterm.lua"
        echo "Removed link: ${CONFIG_DIR}/wezterm/wezterm.lua"
    fi

    if [[ -L "${CONFIG_DIR}/sheldon/plugins.toml" ]]; then
        unlink "${CONFIG_DIR}/sheldon/plugins.toml"
        echo "Removed link: ${CONFIG_DIR}/sheldon/plugins.toml"
    fi

    if [[ -L "${CONFIG_DIR}/starship.toml" ]]; then
        unlink "${CONFIG_DIR}/starship.toml"
        echo "Removed link: ${CONFIG_DIR}/starship.toml"
    fi

    if [[ -L "${HOME}/.zshrc" ]]; then
        unlink "${HOME}/.zshrc"
        echo "Removed link: ${HOME}/.zshrc"
    fi

    if [[ -L "${HOME}/.vimrc" ]]; then
        unlink "${HOME}/.vimrc"
        echo "Removed link: ${HOME}/.vimrc"
    fi

    if [[ -L "${HOME}/.gitconfig" ]]; then
        unlink "${HOME}/.gitconfig"
        echo "Removed link: ${HOME}/.gitconfig"
    fi

    echo "All symbolic links have been removed."
}

# Function to install Homebrew on Linux
setup_homebrew() {
    echo "Setting up Homebrew..."

    # Check if Homebrew is already installed
    if command -v brew &>/dev/null; then
        echo "Homebrew is already installed."
    else
        echo "Homebrew is not installed. Installing Homebrew..."
        
        # Check for required dependencies
        local required_packages=("build-essential" "procps" "curl" "file" "git")
        local missing_packages=()

        for package in "${required_packages[@]}"; do
            if ! dpkg -l | grep -q "^ii  $package"; then
                missing_packages+=("$package")
            fi
        done

        if [[ ${#missing_packages[@]} -ne 0 ]]; then
            echo "The following packages are missing and will be installed: ${missing_packages[*]}"
            sudo apt update
            sudo apt install -y "${missing_packages[@]}"
        else
            echo "All required dependencies are already installed."
        fi

        # Install Homebrew
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # Add Homebrew to the PATH
    test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
    test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    echo "Homebrew setup is complete."
}

# Function to install programs using Brewfile
install_brewfile_packages() {
    echo "Installing packages from Brewfile..."

    if [[ -f "${DOTFILES_DIR}/homebrew/Brewfile" ]]; then
        brew bundle --file="${DOTFILES_DIR}/homebrew/Brewfile"
        echo "Brewfile packages installation is complete."
    else
        echo "Brewfile not found at ${DOTFILES_DIR}/homebrew/Brewfile."
        exit 1
    fi
}

# Function to ensure Homebrew-installed Git is the default Git
setup_git_with_brew() {
    # Check if git is installed via brew
    if brew list --formula | grep "^git\$" &>/dev/null; then
        echo "Git is already installed via Homebrew."
    else
        echo "Git is not installed via Homebrew. Installing now..."
        brew install git
    fi

    # Get the path of the Git installed via Homebrew
    GIT_PATH=$(brew --prefix)/bin/git

    # Get the current Git path
    CURRENT_GIT_PATH=$(which git)

    # Check if the current default Git is the one installed via Homebrew
    if [[ "${CURRENT_GIT_PATH}" == "${GIT_PATH}" ]]; then
        echo "The default Git is already the one installed via Homebrew."
    else
        echo -e "\nSetting the Homebrew-installed Git as the default..."
        echo "export PATH=\"${GIT_PATH}:\$PATH\"" >>"${SHELL_PATH_FILE}"
        echo "The Homebrew-installed Git has been set as the default."
        echo "source ${HOME}/.zshrc or create new terminal for the changes to take effect."
    fi
}

setup_zsh_with_brew() {
    if brew list --formula | grep "^zsh\$" &>/dev/null; then
        echo "zsh is already installed via Homebrew."
    else
        echo "zsh is not installed via Homebrew. Installing now..."
        brew install zsh
    fi

    # Get the path of the zsh installed via Homebrew
    ZSH_PATH=$(brew --prefix)/bin/zsh

    # Check if installed zsh is allowed as a shell, and add a line to /etc/shells.
    if ! grep -Fxq "${ZSH_PATH}" /etc/shells; then
        echo "Adding ${ZSH_PATH} to /etc/shells"
        if [[ ! -e /etc/shells ]]; then
            echo "/etc/shells does not exist. exiting..."
            exit 1
        fi
        echo "${ZSH_PATH}" | sudo tee -a /etc/shells
    fi

    if [[ "${ZSH_PATH}" == "${SHELL}" ]]; then
        echo "Current default shell is of homebrew"
        return
    else
        echo "Changing default shell to the newly installed one."
        chsh -s "${ZSH_PATH}"
    fi
    echo "Set zsh installed via Homebrew as the dafault shell. Create new terminal for the changes to take effect."
}

install_fonts() {
    # TODO: specify fonts in a list. This should not be limited to Cica.
	if fc-list | grep "Cica" &>/dev/null; then
       echo "Cica is already installed"
    else
       echo "Checking whether directory to store fonts exists..."
       if [[ ! -d /usr/local/share/fonts ]]; then
           echo "/usr/local/share/fonts does not exist. exiting..."
           exit 1
       fi
       echo "Donwloading Cica"
       curl -L -O https://github.com/miiton/Cica/releases/download/v5.0.3/Cica_v5.0.3.zip
       unzip Cica_v5.0.3.zip -d Cica
       sudo mv Cica /usr/local/share/fonts
       sudo fc-cache -fv
       if fc-list | grep -q Cica; then
           echo "Cica has successfully installed."
           rm Cica_v5.0.3.zip
       else
           echo "ERROR: Cica has not been installed."
           exit 1
       fi
   fi
}

# Handle script options
case "$1" in
--install-homebrew)
    setup_homebrew
    ;;
--switch-git-with-brew)
    setup_git_with_brew
    ;;
--switch-zsh-with-brew)
    setup_zsh_with_brew
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
--install-fonts)
    install_fonts
    ;;
--all)
    remove_symlinks
    create_symlinks
    setup_homebrew
    setup_zsh_with_brew
    install_brewfile_packages
    setup_git_with_brew # TODO: The operation stops when this one is put right after setup_homebrew.
    install_fonts
    ;;
*)
    echo "Usage: $0 --link | --unlink | --install-homebrew | --install-packages | --install-fonts | --switch-git-with-brew | --switch-zsh-with-brew | --all"
    ;;
esac
