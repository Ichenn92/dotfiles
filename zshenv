# .zshenv - Environment variables for all shells (login and non-login)
# Sourced first, always. Keep minimal - only critical env vars.

# XDG Base Directory specification
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

# Language-specific environment variables
export GEM_HOME="$HOME/.gem"
export NVM_DIR="$HOME/.nvm"

# Cargo environment
if [[ -f "$HOME/.cargo/env" ]]; then
    . "$HOME/.cargo/env"
fi

