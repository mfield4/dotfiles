# Path to your oh-my-zsh installation.
export ZSH="$HOME/.config/zsh/oh-my-zsh"
export ZSH_CUSTOM="$HOME/.config/zsh/custom"

# ── XDG Base Directories & App Caches ─────────────────────

export ZSH_COMPDUMP="$XDG_CACHE_HOME/zsh/zcompdump"

# ── History ───────────────────────────────────────────────
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
mkdir -p "$(dirname "$HISTFILE")"
HISTSIZE=100000
SAVEHIST=100000

setopt INC_APPEND_HISTORY     # write immediately
setopt SHARE_HISTORY          # share across terminals
setopt HIST_IGNORE_ALL_DUPS   # deduplicate older entries
setopt HIST_REDUCE_BLANKS     # trim whitespace
setopt HIST_IGNORE_SPACE      # prefix with space to omit from history

# ── Eternal History ───────────────────────────────────────
autoload -Uz add-zsh-hook
log_to_eternal_history() {
    echo "$(date '+%Y-%m-%d %H:%M:%S %z') $$ $USER $PWD $1" >> "${XDG_STATE_HOME:-$HOME/.local/state}/zsh/eternal_history"
}
add-zsh-hook preexec log_to_eternal_history

# ── PATH ──────────────────────────────────────────────────
typeset -U PATH  # deduplicate PATH entries
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# ── Theme ─────────────────────────────────────────────────
ZSH_THEME="robbyrussell"

# ── Plugins (cross-platform) ─────────────────────────────
# Core plugins that work everywhere
plugins=(
    bazel
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
    python
    repo
    rsync
    sudo
    vscode
    zsh-autosuggestions
    zsh-completions
    zsh-syntax-highlighting
)

# Add OS-specific plugins
case "$(uname -s)" in
    Darwin)
        plugins+=(brew macos)
        ;;
    Linux)
        plugins+=(systemd)
        # Distro-specific plugins
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            case "$ID" in
                arch|endeavouros|manjaro) plugins+=(archlinux) ;;
                opensuse-tumbleweed|opensuse-leap|opensuse) plugins+=(suse) ;;
            esac
        fi
        ;;
esac

source $ZSH/oh-my-zsh.sh

autoload -U compinit && compinit

# ── Useful Aliases ────────────────────────────────────────
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ll="ls -lAh"
alias la="ls -A"
alias md="mkdir -p"
rm() { mv -- "$@" /tmp/; }

# Quick git shortcuts beyond the plugin
alias gst="git status"
alias gd="git diff"
alias gdc="git diff --cached"
alias gl="git log --oneline --graph --decorate -20"

# ── Handy Functions ───────────────────────────────────────

# mkcd: create a directory and cd into it
mkcd() { mkdir -p "$1" && cd "$1"; }

# extract: one command to unpack any archive
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2) tar xjf "$1"   ;;
            *.tar.gz)  tar xzf "$1"   ;;
            *.tar.xz)  tar xJf "$1"   ;;
            *.bz2)     bunzip2 "$1"   ;;
            *.gz)      gunzip "$1"    ;;
            *.tar)     tar xf "$1"    ;;
            *.tbz2)    tar xjf "$1"   ;;
            *.tgz)     tar xzf "$1"   ;;
            *.zip)     unzip "$1"     ;;
            *.Z)       uncompress "$1";;
            *.7z)      7z x "$1"      ;;
            *.zst)     unzstd "$1"    ;;
            *)         echo "'$1' cannot be extracted" ;;
        esac
    else
        echo "'$1' is not a file"
    fi
}

# ── Source OS-specific configurations ─────────────────────
OS_NAME=$(uname -s)
if [[ "$OS_NAME" == "Darwin" ]]; then
    [ -f "$ZDOTDIR/macos.zsh" ] && source "$ZDOTDIR/macos.zsh"
elif [[ "$OS_NAME" == "Linux" ]]; then
    [ -f "$ZDOTDIR/linux.zsh" ] && source "$ZDOTDIR/linux.zsh"
fi

# ── Machine-local overrides (not tracked in git) ─────────
[ -f "$ZDOTDIR/.zshrc.local" ] && source "$ZDOTDIR/.zshrc.local"

# ── Startup ──────────────────────────────────────────────
if command -v fastfetch &>/dev/null; then
    fastfetch
elif command -v neofetch &>/dev/null; then
    neofetch
fi
