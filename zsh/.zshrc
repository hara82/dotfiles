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

# See this document for further information of these options.
# https://zsh.sourceforge.io/Doc/Release/Options.html
setopt HIST_IGNORE_SPACE # Do not save commands starting with a whitespace.
setopt HIST_REDUCE_BLANKS # Remove unnecessary spaces.
setopt inc_append_history     # Write to the history file immediately, not when the shell exits.
setopt hist_ignore_all_dups   # Remove older duplicate entries from history.
setopt share_history          # Share history between different instances of the shell.

setopt correct # Try to correct the spelling of commands. Note
setopt correct_all # Try to correct the spelling of all arguments in a line.
setopt menu_complete # On an ambiguous completion, instead of listing possibilities or beeping, insert the first match immediately. 

# Keep 10000 lines of history within the shell and save it to ~/.zsh_history:
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# Use modern completion system
autoload -Uz compinit
compinit
