# Enable linuxbrew, sheldon, starship, fzf(zsh plugin)
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
eval "$(sheldon source)"
eval "$(starship init zsh)"
source <(fzf --zsh)

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Bind CTRL-P and CTRL-N to search the history using substring search
bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down


setopt HIST_IGNORE_DUPS # Do not save same command in the history.
setopt SHARE_HISTORY    # Share history among zsh process.
setopt HIST_IGNORE_SPACE # Do not save commands starting from whitespace.
setopt HIST_REDUCE_BLANKS # Remove unnecessary spaces.
# Keep 10000 lines of history within the shell and save it to ~/.zsh_history:
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# Use modern completion system
autoload -Uz compinit
compinit
