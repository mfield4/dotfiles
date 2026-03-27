# Linux-specific zsh configuration

# Enable colored output
alias ls="ls --color=auto"
alias grep="grep --color=auto"

# ── Distro-specific config ────────────────────────────────
if [ -f /etc/os-release ]; then
    . /etc/os-release
    case "$ID" in
        opensuse-tumbleweed|opensuse-leap|opensuse)
            # zypper shortcuts
            alias zin='sudo zypper install'
            alias zrm='sudo zypper remove'
            alias zup='sudo zypper dup'          # dup is the right upgrade for Tumbleweed
            alias zse='zypper search'
            alias zif='zypper info'
            alias zref='sudo zypper refresh'

            # systemd helpers (Tumbleweed ships full systemd)
            alias sctl='sudo systemctl'
            alias jctl='sudo journalctl -xe'
            ;;
        arch|endeavouros|manjaro)
            alias pac='sudo pacman'
            ;;
        debian|ubuntu)
            alias apt='sudo apt'
            ;;
    esac
fi
