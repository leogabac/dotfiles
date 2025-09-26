# ==============================================================================
# GLOBAL VARIABLES
# ==============================================================================

# export TERM=xterm-256color
HISTCONTROL=ignoreboth

shopt -s histappend # append to the history file, don't overwrite it
shopt -s checkwinsize

HISTSIZE=1000
HISTFILESIZE=2000

# ==============================================================================
# SETUPS AND BINARY REMAPPINGS
# ==============================================================================

# ===== YAZI SETUP ===== #
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# ==============================================================================
# ALIASES AND MODULES
# ==============================================================================

alias ls='lsd -1'
alias econf='nvim ~/.bashrc && source ~/.bashrc'
alias full_upgrade='~/.scripts/update-btrfs.sh'
alias tarball='tar -cvzf'
alias untar='tar -xvzf'

# ===== TUI ALIASES ===== #
alias cdf='source ~/.scripts/cd-fzf.sh .' # avoid subshell
alias penv='source ~/.scripts/tui/pyenvs.sh .' # avoid subshell
alias gactive='source $(git rev-parse --show-toplevel)/.venv/bin/activate'

# ===== NEOVIM ===== #
alias lvim='NVIM_APPNAME="nvim-lazyvim" nvim'

# ===== REMOTE CONNETIONS ===== #
if [ -f ~/.ssh_aliases ]; then
  . ~/.ssh_aliases
fi

# export GSETTINGS_SCHEMA_DIR=/usr/share/glib-2.0/schemas/
# export QT_QPA_PLATFORM=xcb

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/share/gem/ruby/3.4.0/bin:$PATH"

# Install Ruby Gems to ~/gems
export GEM_HOME="$HOME/.gems"
export PATH="$HOME/.gems/bin:$PATH"


# ===== STARSHIP SETUP ===== #
eval "$(starship init bash)"
