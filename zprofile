# .zprofile - Commands for login shells only
# Sourced before .zshrc for login shells. Used for setting up the PATH.

# Homebrew - must be early for other tools to use brew-installed binaries
if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# PATH additions (order matters - earlier entries take precedence)
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"  # Java
export PATH="$HOME/.rbenv/bin:$PATH"              # rbenv
export PATH="$HOME/.gem/bin:$PATH"                # Ruby gems
export PATH="$HOME/.pub-cache/bin:$PATH"          # Flutter global binaries

# Ruby environment (rbenv)
if command -v rbenv >/dev/null 2>&1; then
    eval "$(rbenv init - zsh)"
fi

# NVM (Node Version Manager) - lazy load for performance
# Prefer nvm node over Homebrew node
export NVM_DIR="$HOME/.nvm"
if [[ -s "/opt/homebrew/opt/nvm/nvm.sh" ]]; then
  . "/opt/homebrew/opt/nvm/nvm.sh"
fi

# Created by `pipx` on 2025-10-31 22:05:25
export PATH="$PATH:/Users/tristan/.local/bin"
