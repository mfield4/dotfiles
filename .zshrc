# If you come from bash you might have to change your $PATH.

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export LIBVA_DRIVER_NAME="nvidia"
export MOZ_DISABLE_RDD_SANDBOX=1

# Add to path
export PATH=/$HOME/.local/bin:$PATH
export PATH=/$HOME/bin:$PATH

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
#ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell", "agnoster" )


# Zsh plugins
plugins=(
	archlinux
	docker
	docker-compose
	emoji
	git
	git-lfs
	git-auto-fetch
	git-prompt
	git-escape-magic
	gitignore
	golang
	history
	pip
	pipenv
	python
	repo
	rsync
	sudo
	systemd
	vscode
	zsh-autosuggestions
	zsh-completions
	zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

autoload -U compinit && compinit


# Add a pretty print at the end
neofetch
