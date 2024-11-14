# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

# Application aliases
alias mc="mutagen-compose"
alias gitup="git checkout main && git pull origin main && git checkout - && git merge main"
alias gitlog="git log --all --decorate --oneline --graph"
alias cleandns="sudo killall -HUP mDNSResponder && sudo dscacheutil -flushcache"
# gitprunemerged will clean your local branch (since we squash our PR) git can't recognize your local branch as fully merged (commit history have changed)
alias gitprunemerged='git checkout -q main && git for-each-ref refs/heads/ "--format=%(refname:short)" | while read branch; do mergeBase=$(git merge-base main $branch) && [[ $(git cherry main $(git commit-tree $(git rev-parse "$branch^{tree}") -p $mergeBase -m _)) == "-"* ]] && git branch -D $branch; done'
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
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nv
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
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"

alias aladark="ln -fs ~/.config/alacritty/themes/themes/google.toml ~/.config/alacritty/themes/themes/_active.toml"
alias alalight="ln -fs ~/.config/alacritty/themes/themes/pencil_light.toml ~/.config/alacritty/themes/themes/_active.toml"
func alatheme() {
  ln -fs ~/.config/alacritty/themes/themes/$1.toml ~/.config/alacritty/themes/themes/_active.toml
}

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

