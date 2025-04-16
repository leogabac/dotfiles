# ==============================================================================
# QUICK AESTHETICS
# ==============================================================================

# function to get the current git branch
parse_git_branch() {
  git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# trim the directory to show only the last folder
PROMPT_DIRTRIM=1
export PROMPT_COMMAND='PS1_CMD1=$(parse_git_branch)'
PS1='\[\e[1m\][\[\e[32m\]\u\[\e[39m\]]\[\e[0m\] \[\e[96;1m\]\w\[\e[0m\]\[\e[1m\]${PS1_CMD1}\[\e[0m\]>'


# ==============================================================================
# GLOBAL VARIABLES
# ==============================================================================
HISTCONTROL=ignoreboth

shopt -s histappend # append to the history file, don't overwrite it

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

# mount BIG with write permissions
alias mBIG='sudo mount /dev/sda2 ~/BIG/ -o umask=000'

# ===== SYSTEM ALIASES ===== #
alias full_upgrade='~/.scripts/update.sh'

# ===== TUI ALIASES ===== #
alias cdf='source ~/.scripts/cd-fzf.sh' # avoid subshell
alias pdfmerge='~/.scripts/tui/pdfmerge.sh'
alias ypdf='~/.scripts/tui/pdfmerge_yazi.sh'
alias cm='~/.scripts/tui/quick_commits.sh'

# ===== NEOVIM ===== #
alias lvim='NVIM_APPNAME="nvim-lazyvim" nvim'

# ===== TMUX ===== #
# give a warning if tmux is not installed
if ! command -v tmux > /dev/null 2>&1; then
  echo -e "\e[33m WARNING: tmux is not installed\e[0m"
fi

alias thesis='~/.scripts/tmux/thesis.sh'
alias tss='~/.scripts/tmux/tmux-sessionizer.sh'

# ===== REMOTE CONNETIONS ===== #
if [ -f ~/.bash/ssh_aliases ]; then
  . ~/.bash/ssh_aliases
fi

# ===== LSD SETUP ===== #
if command -v lsd > /dev/null 2>&1; then
  alias ls='lsd'
else
  echo -e "\e[33m WARNING: lsd is not installed\e[0m"
fi

# ===== PYTHON ENVIRONMENTS ===== #
alias ice="source ~/.virtualenvs/ice/bin/activate"
alias uncertainty="source ~/.virtualenvs/uncertainty/bin/activate"
alias demucs_env="source ~/.virtualenvs/demucs/bin/activate"
alias py312="source ~/.virtualenvs/py3.12/bin/activate"export GSETTINGS_SCHEMA_DIR=/usr/share/glib-2.0/schemas/

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"

export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/share/gem/ruby/3.3.0/bin:$PATH"


# ===== ZOXIDE SETUP ===== #
if command -v zoxide > /dev/null 2>&1; then
  eval "$(zoxide init bash)"
  alias cd='z'
else
  echo -e "\e[33m WARNING: zoxide is not installed\e[0m"
fi


# Install Ruby Gems to ~/gems
export GEM_HOME="$HOME/gems"
export PATH="$HOME/gems/bin:$PATH"
