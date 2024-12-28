alias cat="bat --style=plain"
alias ls="eza"
alias tree="eza -T"
alias abbr="abbrev-alias"
alias imgcat="wezterm imgcat"

abbr up="cd .."
abbr d="docker"
abbr -r dcp="d compose"
abbr -r dc="d container"
abbr gc="git commit"
abbr gs="git status"
abbr ggl="google"

# Enable Delete key
# https://superuser.com/questions/169920/binding-fn-delete-in-zsh-on-mac-os-x
bindkey "^[[3~" delete-char

