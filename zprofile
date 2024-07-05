# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"

alias aladark="ln -fs ~/.config/alacritty/themes/themes/one_dark.toml ~/.config/alacritty/themes/themes/_active.toml"
alias alalight="ln -fs ~/.config/alacritty/themes/themes/pencil_light.toml ~/.config/alacritty/themes/themes/_active.toml"
func alatheme() {
  ln -fs ~/.config/alacritty/themes/themes/$1.toml ~/.config/alacritty/themes/themes/_active.toml
}
