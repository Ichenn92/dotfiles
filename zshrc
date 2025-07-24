# Neovim Performance Management Alias
alias nvim-perf="$HOME/.dotfiles/scripts/nvim-performance.sh"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

# Application aliases
alias cleandns="sudo killall -HUP mDNSResponder && sudo dscacheutil -flushcache"
# ---- Eza (better ls) ----
alias ls="eza --icons=always"
# ---- Zoxide (better cd) ----
alias cd="z"
eval "$(zoxide init zsh)"

export GEM_HOME="$HOME/.gem"
export PATH="$PATH:$HOME/.rbenv/bin"
export PATH="$PATH:$HOME/.gem/bin"
eval "$(rbenv init - zsh)"

# Java injected binary.
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

# Flutter global binaries
export PATH="$PATH":"$HOME/.pub-cache/bin"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f /Users/tristan/.dart-cli-completion/zsh-config.zsh ]] && . /Users/tristan/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/tristan/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/tristan/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/tristan/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/tristan/google-cloud-sdk/completion.zsh.inc'; fi

# history setup
# HISTFILE=$HOME/.zhistory
# SAVEHIST=1000
# HISTSIZE=999
# setopt share_history
# setopt hist_expire_dups_first
# setopt hist_ignore_dups
# setopt hist_verify

# bindkey "^[[A" history-search-backward
# bindkey "^[[B" history-search-forward

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"

kill_port() {
    local port=$1
    if [ -z "$port" ]; then
        echo "Please provide a port number."
        return 1
    fi

    lsof -ti tcp:"$port" | xargs kill -9 2>/dev/null
    sleep 1  # Allow some time for the process to be killed

    if lsof -i tcp:"$port" > /dev/null; then
        echo "Port $port is still listening."
    else
        echo "Port $port has been successfully killed."
    fi
}
