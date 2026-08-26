#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_DIR=$(cd "$SCRIPT_DIR/.." && pwd)
CHECK_TMP=$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-check.XXXXXX")

cleanup() {
    case "$CHECK_TMP" in
        "${TMPDIR:-/tmp}"/dotfiles-check.*)
            rm -rf "$CHECK_TMP"
            ;;
    esac
}
trap cleanup EXIT

section() {
    printf '\n==> %s\n' "$1"
}

optional_tool() {
    local tool=$1
    if command -v "$tool" >/dev/null 2>&1; then
        return 0
    fi
    if [[ ${CI:-false} == true ]]; then
        printf 'Required CI tool is missing: %s\n' "$tool" >&2
        return 1
    fi
    printf 'warning: skipping unavailable tool: %s\n' "$tool" >&2
    return 1
}

cd "$REPO_DIR"

section "Shell syntax"
bash -n install scripts/bootstrap-macos.sh scripts/check.sh scripts/nvim-performance.sh
zsh -n zshenv zprofile zshrc p10k.zsh
if optional_tool shellcheck; then
    shellcheck install scripts/bootstrap-macos.sh scripts/check.sh scripts/nvim-performance.sh
fi

section "YAML and TOML"
PYTHONPATH="$REPO_DIR/dotbot/lib/pyyaml/lib" python3 -c \
    'import pathlib, yaml; yaml.safe_load(pathlib.Path("install.conf.yaml").read_text())'
python3 -c \
    'import pathlib, tomllib; tomllib.loads(pathlib.Path("aerospace/aerospace.toml").read_text())'

section "Homebrew manifests"
if command -v brew >/dev/null 2>&1; then
    HOMEBREW_NO_AUTO_UPDATE=1 brew bundle list --file Brewfile >/dev/null
    HOMEBREW_NO_AUTO_UPDATE=1 brew bundle list --file Brewfile.desktop >/dev/null
else
    echo "warning: Homebrew is unavailable; Brewfile parsing skipped" >&2
fi

section "Portable tracked paths"
absolute_home_pattern='/''Users/'
if rg -n "$absolute_home_pattern" \
    --glob '!dotbot/**' \
    --glob '!.git/**' \
    --glob '!scripts/check.sh' .; then
    echo "Tracked absolute macOS home path detected." >&2
    exit 1
fi

section "Secret scan"
if optional_tool gitleaks; then
    gitleaks git --redact --no-banner
    gitleaks dir --redact --no-banner .
fi

section "Dotbot idempotence"
TEST_HOME="$CHECK_TMP/home"
mkdir -p "$TEST_HOME/.config/ghostty"
touch "$TEST_HOME/.aerospace.toml" "$TEST_HOME/.config/ghostty/config"
HOME="$TEST_HOME" "$REPO_DIR/install" --no-color
HOME="$TEST_HOME" "$REPO_DIR/install" --no-color

if ! compgen -G "$TEST_HOME/.aerospace.toml.dotfiles-backup.*" >/dev/null || \
    ! compgen -G "$TEST_HOME/.config/ghostty.dotfiles-backup.*" >/dev/null; then
    echo "Existing application configuration was not backed up." >&2
    exit 1
fi

for target in \
    .gitconfig \
    .ssh/config \
    .aerospace.toml \
    .config/nvim \
    .config/ghostty; do
    if [[ ! -L "$TEST_HOME/$target" ]]; then
        printf 'Expected Dotbot symlink is missing: %s\n' "$target" >&2
        exit 1
    fi
done

section "Neovim startup"
if command -v nvim >/dev/null 2>&1; then
    NVIM_DATA="$CHECK_TMP/nvim-data"
    mkdir -p "$NVIM_DATA/nvim"

    if [[ ${DOTFILES_NVIM_SYNC:-false} == true ]]; then
        DOTFILES_CHECK=1 \
        XDG_CONFIG_HOME="$REPO_DIR/config" \
        XDG_DATA_HOME="$NVIM_DATA" \
        XDG_STATE_HOME="$CHECK_TMP/nvim-state" \
        XDG_CACHE_HOME="$CHECK_TMP/nvim-cache" \
            nvim --headless "+Lazy! sync" +qa
    elif [[ -d "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/lazy" ]]; then
        ln -s "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/lazy" "$NVIM_DATA/nvim/lazy"
    fi

    DOTFILES_CHECK=1 \
    XDG_CONFIG_HOME="$REPO_DIR/config" \
    XDG_DATA_HOME="$NVIM_DATA" \
    XDG_STATE_HOME="$CHECK_TMP/nvim-state" \
    XDG_CACHE_HOME="$CHECK_TMP/nvim-cache" \
        nvim --headless +qa
else
    echo "warning: Neovim is unavailable; startup test skipped" >&2
fi

echo
echo "All available checks passed."
