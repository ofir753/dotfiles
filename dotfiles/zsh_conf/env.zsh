
# ---------------------------
#		 ENV VARS
# ---------------------------

# Skip global compinit before addons
skip_global_compinit=1

# Check if remote
export IS_REMOTE=false
if test -f "$HOME/.remote_indicator"; then
	export IS_REMOTE=true
fi

# Check if sudo
export NO_SUDO=false
if test -f "$HOME/.no_sudo_indicator"; then
	export NO_SUDO=true
fi

# Check if WSL
export WSL=false
if [[ $(uname -a) == *"Microsoft"* ]]; then
	export WSL=true
fi

# Export Local pkgs if on remote (non-root usage)
if $NO_SUDO; then
	export PATH="$HOME/pkgs/usr/sbin:$HOME/pkgs/usr/bin:$HOME/pkgs/bin:$PATH"
	export MANPATH="$HOME/pkgs/usr/share/man:$MANPATH"

	L='/lib:/lib64:/usr/lib:/usr/lib64'
	export LD_LIBRARY_PATH="$HOME/pkgs/usr/lib:$HOME/pkgs/usr/lib64:$L"
	[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
fi

# ---------------------------
# Env vars
# ---------------------------
# GOLANG
export GOROOT=/usr/local/go
export GOPATH=~/go/
export CGO_ENABLED=0

export PATH=~/.local/bin:~/dotfiles_scripts/notify:~/dotfiles_scripts/misc:~/dotfiles_scripts/inner:~/dotfiles_scripts/deploy/:~/dotfiles_scripts/git:~/dotfiles_scripts/tmux_layouts/:$GOPATH/bin:$GOROOT/bin:$PATH
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export EDITOR='vim'
if type nvim &> /dev/null; then
	alias vi='vim'
	export EDITOR='nvim'

	# nvim as man viewer
	export MANPAGER='nvim +Man!'
	export MANWIDTH=999
fi
