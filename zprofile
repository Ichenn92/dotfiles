# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"

alias aladark="ln -fs ~/.config/alacritty/themes/themes/catppuccin_frappe.toml ~/.config/alacritty/themes/themes/_active.toml"
alias alalight="ln -fs ~/.config/alacritty/themes/themes/catppuccin_latte.toml ~/.config/alacritty/themes/themes/_active.toml"
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
