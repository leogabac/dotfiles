
# ==============================================================================
# SETUPS AND BINARY REMAPPINGS
# ==============================================================================

function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end

# ==============================================================================
# ALIASES AND MODULES
# ==============================================================================

alias ls 'lsd -1'
alias full_upgrade '~/.scripts/update-btrfs.sh'
alias tarball 'tar -cvzf'
alias untar 'tar -xvzf'
alias gactive 'source (git rev-parse --show-toplevel)/.venv/bin/activate.fish'


abbr gs 'git status'
abbr gall 'git add .'
abbr gcm 'git commit -m'

abbr pacs 'sudo pacman -S'
abbr pacq 'sudo pacman -Q'

# ==============================================================================
# STARSHIP SETUP
# ==============================================================================

starship init fish | source

set -x PATH $HOME/.local/bin $PATH
set -x PATH $HOME/.local/share/gem/ruby/3.4.0/bin $PATH
set -Ux PYENV_ROOT $HOME/.pyenv
