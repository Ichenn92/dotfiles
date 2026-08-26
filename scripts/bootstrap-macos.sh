#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_DIR=$(cd "$SCRIPT_DIR/.." && pwd)
WITH_DESKTOP=false
DRY_RUN=false

usage() {
    cat <<'USAGE'
Usage: ./scripts/bootstrap-macos.sh [--desktop] [--dry-run]

  --desktop  Also install AeroSpace, Ghostty, borders, and desktop helpers.
  --dry-run  Print the commands without changing the system.
  --help     Show this help message.
USAGE
}

print_command() {
    printf '+'
    printf ' %q' "$@"
    printf '\n'
}

run() {
    print_command "$@"
    if [[ $DRY_RUN == false ]]; then
        "$@"
    fi
}

for argument in "$@"; do
    case "$argument" in
        --desktop)
            WITH_DESKTOP=true
            ;;
        --dry-run)
            DRY_RUN=true
            ;;
        --help|-h)
            usage
            exit 0
            ;;
        *)
            printf 'Unknown option: %s\n\n' "$argument" >&2
            usage >&2
            exit 2
            ;;
    esac
done

if [[ $(uname -s) != Darwin ]]; then
    echo "This bootstrap supports macOS only." >&2
    exit 1
fi

find_brew() {
    if command -v brew >/dev/null 2>&1; then
        command -v brew
    elif [[ -x /opt/homebrew/bin/brew ]]; then
        printf '%s\n' /opt/homebrew/bin/brew
    elif [[ -x /usr/local/bin/brew ]]; then
        printf '%s\n' /usr/local/bin/brew
    else
        return 1
    fi
}

BREW_BIN=$(find_brew || true)
if [[ -z $BREW_BIN ]]; then
    if [[ $DRY_RUN == true ]]; then
        echo "+ download and run the official Homebrew installer"
        BREW_BIN=/opt/homebrew/bin/brew
    else
        printf 'Homebrew is not installed. Install it from the official installer? [y/N] '
        read -r answer
        if [[ ! $answer =~ ^[Yy]$ ]]; then
            echo "Homebrew installation cancelled." >&2
            exit 1
        fi

        INSTALLER=$(mktemp "${TMPDIR:-/tmp}/homebrew-install.XXXXXX")
        trap 'rm -f "$INSTALLER"' EXIT
        run curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh -o "$INSTALLER"
        run /bin/bash "$INSTALLER"
        BREW_BIN=$(find_brew)
    fi
fi

if [[ $DRY_RUN == false ]]; then
    eval "$("$BREW_BIN" shellenv)"
fi

run "$BREW_BIN" bundle --file "$REPO_DIR/Brewfile" --no-upgrade
if [[ $WITH_DESKTOP == true ]]; then
    run "$BREW_BIN" bundle --file "$REPO_DIR/Brewfile.desktop" --no-upgrade
fi

run "$REPO_DIR/install"

if [[ $WITH_DESKTOP == true ]]; then
    if [[ $DRY_RUN == true ]]; then
        echo
        echo "Dry run complete; no desktop packages or links were changed."
        exit 0
    fi
    cat <<'NEXT_STEPS'

Desktop packages are installed. Complete the user-approved macOS steps:
  open -a Ghostty
  brew services start thurstonsand/tap/ghosttykit
  gty doctor
  aerospace reload-config
NEXT_STEPS
fi
