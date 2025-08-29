# ==============================================================================
# QUICK AESTHETICS
# ==============================================================================
#

# git_branch() {
#   git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
# }

# PROMPT_DIRTRIM=1
# export PROMPT_COMMAND='PS1_CMD1=$(git_branch)'
# PS1='\[\e[1m\][\[\e[32m\]\u\[\e[39m\]]\[\e[0m\] \[\e[96;1m\]\w\[\e[0m\]\[\e[1m\]${PS1_CMD1}\[\e[0m\]>'
#

# ==============================================================================
# GLOBAL VARIABLES
# ==============================================================================

HISTCONTROL=ignoreboth

shopt -s histappend # append to the history file, don't overwrite it
shopt -s checkwinsize

HISTSIZE=1000
HISTFILESIZE=2000

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

alias ls='lsd -1'
alias econf='nvim ~/.bashrc'
alias reload='source ~/.bashrc'
alias full_upgrade='~/.scripts/update-btrfs.sh'
alias fqinfo='cpupower frequency-info'

alias tarball='tar -cvzf'
alias untar='tar -xvzf'

# alias mBIG='sudo mount /dev/sda2 ~/BIG/ -o umask=000'

# ===== TUI ALIASES ===== #
alias cdf='source ~/.scripts/cd-fzf.sh .' # avoid subshell
alias penv='source ~/.scripts/tui/pyenvs.sh .' # avoid subshell
alias ypdf='~/.scripts/tui/pdfmerge_yazi.sh'
alias cm='~/.scripts/tui/quick_commits.sh'
alias matlab='distrobox enter ubuntu-jammy -- /home/holo/matlab/bin/matlab -softwareopengl'
alias git-root='git rev-parse --show-toplevel'
alias pactive='source .venv/bin/activate'
alias gactive='source $(git-root)/.venv/bin/activate'
alias win-container='xfreerdp3 /u:"leogabac" /p:"n1n23n23" /v:127.0.0.1 /cert:tofu /f /scale:180'

# ===== NEOVIM ===== #
alias lvim='NVIM_APPNAME="nvim-lazyvim" nvim'

# ===== TMUX ===== #
alias tss='~/.scripts/tmux/tmux-sessionizer.sh'

# ===== REMOTE CONNETIONS ===== #
if [ -f ~/.ssh_aliases ]; then
  . ~/.ssh_aliases
fi

# ===== PYTHON ENVIRONMENTS ===== #
alias ice="source ~/.venvs/ice/bin/activate"
alias nb="~/.scripts/tmux/notebook.sh"
alias uncertainty="source ~/.virtualenvs/uncertainty/bin/activate"
alias demucs_env="source ~/.virtualenvs/demucs/bin/activate"
alias py312="source ~/.virtualenvs/py3.12/bin/activate"export GSETTINGS_SCHEMA_DIR=/usr/share/glib-2.0/schemas/

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"

export PATH="$HOME/bin:$PATH"
export PATH="$HOME/local/bin:$PATH"
export PATH="$HOME/.local/share/gem/ruby/3.4.0/bin:$PATH"


# ===== STARSHIP SETUP ===== #
eval "$(starship init bash)"

# ===== ZOXIDE SETUP ===== #
eval "$(zoxide init bash)"
#alias cd='z'


# Install Ruby Gems to ~/gems
export GEM_HOME="$HOME/.gems"
export PATH="$HOME/.gems/bin:$PATH"
