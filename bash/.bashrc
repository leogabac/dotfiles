# ==============================================================================
# GLOBAL VARIABLES
# ==============================================================================

HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# ===== GENERAL ALISES ===== #
alias econf='nvim ~/.bashrc && source ~/.bashrc'
alias reload='source ~/.bashrc'

# ==============================================================================
# SETUPS AND BINARY REMAPPINGS
# ==============================================================================

# ===== ZOXIDE SETUP ===== #
if command -v zoxide > /dev/null 2>&1; then
  eval "$(zoxide init bash)"
  alias cd='z'
else
  echo -e "\e[33m WARNING: zoxide is not installed\e[0m"
fi

# ===== YAZI SETUP ===== #
if command -v yazi > /dev/null 2>&1; then
  function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
      builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
  }
else
  echo -e "\e[33m WARNING: yazi is not installed\e[0m"
fi

# ==============================================================================
# ALIASES AND MODULES
# ==============================================================================

# ===== AESTHETICS ===== #
if [ -f ~/.bash/aesthetics ]; then
  . ~/.bash/aesthetics
fi

# ===== COMPLETIONS ===== #
# i actually don't know what these are, but left them just in case
if [ -f ~/.bash/aesthetics ]; then
  . ~/.bash/completions
fi

# ===== GENERAL ALIASES ===== #
if [ -f ~/.bash/general_aliases ]; then
  . ~/.bash/general_aliases
fi

# ===== GIT CLONE REPOS ===== #
if [ -f ~/.bash/gitclone_aliases ]; then
  . ~/.bash/gitclone_aliases
fi

# ===== TMUX ===== #
if [ -f ~/.bash/tmux_aliases ]; then
  . ~/.bash/tmux_aliases
fi

# ===== REMOTE CONNETIONS ===== #
if [ -f ~/.bash/ssh_aliases ]; then
  . ~/.bash/ssh_aliases
fi

# ===== LSD SETUP ===== #
# i am not sure why, but at the beginning, this does not work
if command -v lsd > /dev/null 2>&1; then
  alias ls='lsd'
else
  echo -e "\e[33m WARNING: lsd is not installed\e[0m"
fi

# ===== PYTHON ENVIRONMENTS ===== #
if [ -f ~/.bash/virtualenv_aliases ]; then
  . ~/.bash/virtualenv_aliases
fi

#export DRI_PRIME=1

export GSETTINGS_SCHEMA_DIR=/usr/share/glib-2.0/schemas/
