# Interactive shell configuration.

# Powerlevel10k instant prompt must remain near the top of this file.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

setopt AUTO_CD
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY

HISTSIZE=10000
SAVEHIST=10000
HISTFILE="$HOME/.zsh_history"

if [[ -z ${HOMEBREW_PREFIX:-} ]] && command -v brew >/dev/null 2>&1; then
    HOMEBREW_PREFIX=$(brew --prefix)
fi

if [[ -n ${HOMEBREW_PREFIX:-} && -f "$HOMEBREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
    source "$HOMEBREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme"
fi
[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

if [[ -n ${HOMEBREW_PREFIX:-} && -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
    alias cd="z"
fi

if [[ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]]; then
    source "$HOME/google-cloud-sdk/path.zsh.inc"
fi
if [[ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]]; then
    source "$HOME/google-cloud-sdk/completion.zsh.inc"
fi
if [[ -f "$HOME/.config/.dart-cli-completion/zsh-config.zsh" ]]; then
    source "$HOME/.config/.dart-cli-completion/zsh-config.zsh"
fi

alias cleandns="sudo killall -HUP mDNSResponder && sudo dscacheutil -flushcache"
if command -v eza >/dev/null 2>&1; then
    alias ls="eza --icons=always"
fi
alias nvim-perf="$HOME/.dotfiles/scripts/nvim-performance.sh"

kill_port() {
    local port=$1
    local attempt
    local -a pids

    if [[ ! "$port" =~ '^[0-9]+$' ]] || (( port < 1 || port > 65535 )); then
        echo "Usage: kill_port <port_number>"
        return 1
    fi

    pids=("${(@f)$(lsof -tiTCP:"$port" -sTCP:LISTEN 2>/dev/null)}")
    pids=(${pids:#})
    if (( ${#pids} == 0 )); then
        echo "No process found listening on port $port"
        return 0
    fi

    kill -TERM "${pids[@]}" 2>/dev/null || true
    for attempt in {1..10}; do
        lsof -tiTCP:"$port" -sTCP:LISTEN >/dev/null 2>&1 || break
        sleep 0.2
    done

    if lsof -tiTCP:"$port" -sTCP:LISTEN >/dev/null 2>&1; then
        kill -KILL "${pids[@]}" 2>/dev/null || true
    fi

    if lsof -tiTCP:"$port" -sTCP:LISTEN >/dev/null 2>&1; then
        echo "Failed to stop process on port $port"
        return 1
    fi

    echo "Stopped process on port $port"
}

if [[ -s "$HOME/.bun/_bun" ]]; then
    source "$HOME/.bun/_bun"
fi
if [[ -d "$HOME/.bun/bin" ]]; then
    typeset -U path PATH
    path=("$HOME/.bun/bin" $path)
fi

# Syntax highlighting should be the last sourced Zsh plugin.
if [[ -n ${HOMEBREW_PREFIX:-} && -f "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
