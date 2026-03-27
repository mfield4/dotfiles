# macOS-specific zsh configuration

# Add Homebrew to PATH if available (Apple Silicon or Intel)
if [ -d "/opt/homebrew/bin" ]; then
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
elif [ -d "/usr/local/bin" ]; then
  export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
fi

# Color output for ls
alias ls="ls -G"
