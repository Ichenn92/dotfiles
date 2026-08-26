# Login-shell environment and PATH setup.

# Homebrew uses /opt/homebrew on Apple Silicon and /usr/local on Intel Macs.
if command -v brew >/dev/null 2>&1; then
    eval "$(brew shellenv)"
elif [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

typeset -U path PATH
path=(
    "$HOME/.local/bin"
    "$HOME/.rbenv/bin"
    "$HOME/.gem/bin"
    "$HOME/.pub-cache/bin"
    $path
)

if [[ -n ${HOMEBREW_PREFIX:-} && -d "$HOMEBREW_PREFIX/opt/openjdk@17/bin" ]]; then
    path=("$HOMEBREW_PREFIX/opt/openjdk@17/bin" $path)
fi

if command -v rbenv >/dev/null 2>&1; then
    eval "$(rbenv init - zsh)"
fi

export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
if [[ -n ${HOMEBREW_PREFIX:-} && -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ]]; then
    source "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
fi
