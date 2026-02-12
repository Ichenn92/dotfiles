# .zshrc - Interactive shell configuration
# Sourced for interactive shells. Aliases, functions, prompt, keybindings, etc.

# ============================================================================
# POWERLEVEL10K INSTANT PROMPT (must be at top)
# ============================================================================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ============================================================================
# ZSH OPTIONS
# ============================================================================
setopt AUTO_CD              # Change directory without cd
setopt HIST_IGNORE_ALL_DUPS # Remove older duplicate entries from history
setopt HIST_REDUCE_BLANKS   # Remove superfluous blanks from history
setopt SHARE_HISTORY        # Share history between sessions
setopt INC_APPEND_HISTORY   # Write to history immediately

# History configuration
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# ============================================================================
# PROMPT (POWERLEVEL10K)
# ============================================================================
if [[ -f "/opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
    source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
fi

# Powerlevel10k configuration
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# ============================================================================
# ZSH PLUGINS
# ============================================================================
# Note: syntax-highlighting must be loaded last
if [[ -f "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

if [[ -f "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# ============================================================================
# TOOL INITIALIZATIONS
# ============================================================================
# Zoxide (better cd)
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi

# ============================================================================
# COMPLETION SYSTEMS
# ============================================================================
# Dart CLI completion
if [[ -f "$HOME/.dart-cli-completion/zsh-config.zsh" ]]; then
    source "$HOME/.dart-cli-completion/zsh-config.zsh"
fi

# Google Cloud SDK
if [[ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]]; then
    source "$HOME/google-cloud-sdk/path.zsh.inc"
fi

if [[ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]]; then
    source "$HOME/google-cloud-sdk/completion.zsh.inc"
fi

# NVM bash completion (if needed for interactive use)
if [[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ]]; then
    source "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
fi

# ============================================================================
# ALIASES
# ============================================================================
# System utilities
alias cleandns="sudo killall -HUP mDNSResponder && sudo dscacheutil -flushcache"

# Enhanced tools
alias ls="eza --icons=always"
alias cd="z"  # Use zoxide instead of cd

# Custom scripts
alias nvim-perf="$HOME/.dotfiles/scripts/nvim-performance.sh"

# ============================================================================
# FUNCTIONS
# ============================================================================
# Kill process on specified port
kill_port() {
    local port=$1
    if [[ -z "$port" ]]; then
        echo "Usage: kill_port <port_number>"
        return 1
    fi

    local pids=$(lsof -ti tcp:"$port" 2>/dev/null)
    if [[ -z "$pids" ]]; then
        echo "No process found listening on port $port"
        return 0
    fi

    echo "$pids" | xargs kill -9 2>/dev/null
    sleep 0.5

    if lsof -i tcp:"$port" >/dev/null 2>&1; then
        echo "Failed to kill process on port $port"
        return 1
    else
        echo "Successfully killed process on port $port"
    fi
}

# Created by `pipx` on 2025-10-31 22:05:25
export PATH="$PATH:/Users/tristan/.local/bin"

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f /Users/tristan/.config/.dart-cli-completion/zsh-config.zsh ]] && . /Users/tristan/.config/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]


# bun completions
[ -s "/Users/tristan/.bun/_bun" ] && source "/Users/tristan/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
