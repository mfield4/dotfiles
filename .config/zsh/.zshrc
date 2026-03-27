# If you come from bash you might have to change your $PATH.

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set up standard history file and sizes (adjust sizes as preferred)
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000

# Append commands to the history file immediately after execution
setopt INC_APPEND_HISTORY
# Share across open terminals immediately
setopt SHARE_HISTORY

# Load the hook function module
autoload -Uz add-zsh-hook

# Define the logging function with a macOS-compatible date format
log_to_eternal_history() {
    # Uses standard format string: YYYY-MM-DD HH:MM:SS Timezone
    echo "$(date '+%Y-%m-%d %H:%M:%S %z') $$ $USER $PWD $1" >> ~/.zsh_eternal_history
}

# Attach our function to the preexec hook
add-zsh-hook preexec log_to_eternal_history

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


# Source OS-specific configurations
OS_NAME=$(uname -s)
if [[ "$OS_NAME" == "Darwin" ]]; then
    [ -f "$ZDOTDIR/macos.zsh" ] && source "$ZDOTDIR/macos.zsh"
elif [[ "$OS_NAME" == "Linux" ]]; then
    [ -f "$ZDOTDIR/linux.zsh" ] && source "$ZDOTDIR/linux.zsh"
fi

# Source local machine-specific overrides (not tracked in git)
[ -f "$ZDOTDIR/.zshrc.local" ] && source "$ZDOTDIR/.zshrc.local"

# Add a pretty print at the end
neofetch
