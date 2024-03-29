export PATH="/usr/local/opt/ruby/bin:$PATH"
export EDITOR="code -w"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

echo 'eval "$(pyenv init -)"' >> ~/.bash_profile
alias serve='ruby -run -e httpd . -p 8000'

alias typora="open -a typora"
