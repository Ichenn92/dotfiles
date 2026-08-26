# macOS dotfiles

Portable macOS configuration managed with [Dotbot](https://github.com/anishathalye/dotbot). The repository contains shell, Git/SSH, Neovim, AeroSpace, and Ghostty configuration plus declarative Homebrew manifests. Personal identities, credentials, API keys, and application data are intentionally excluded.

## Repository layout

| Path | Purpose |
| --- | --- |
| `install` / `install.conf.yaml` | Idempotent Dotbot symlink installation |
| `Brewfile` | Command-line and development baseline |
| `Brewfile.desktop` | Optional AeroSpace/Ghostty desktop environment |
| `zshenv`, `zprofile`, `zshrc`, `profile` | Shell environment and interactive configuration |
| `gitconfig`, `ssh/config` | Public defaults that include private local overrides |
| `config/nvim` | Neovim configuration and locked plugins |
| `aerospace` | AeroSpace window manager configuration |
| `config/ghostty` | Ghostty key bindings and focused-pane shader |
| `scripts` | Bootstrap, diagnostics, and validation commands |
| `dotbot` | Pinned Dotbot Git submodule |

## Install

Clone the repository with its submodule, then choose one of the following flows.

```sh
git clone --recurse-submodules <repository-url> "$HOME/.dotfiles"
cd "$HOME/.dotfiles"

# Symlinks only
./install

# Homebrew CLI/dev packages followed by symlinks
./scripts/bootstrap-macos.sh

# CLI/dev packages plus AeroSpace and Ghostty
./scripts/bootstrap-macos.sh --desktop
```

Use `./scripts/bootstrap-macos.sh --dry-run --desktop` to preview commands. The bootstrap never runs `brew bundle cleanup` and therefore never removes packages that are not in these manifests.

## Private local configuration

The tracked configuration is safe to publish. Create the local files below for machine-specific identities:

```sh
install -m 600 examples/gitconfig.local.example "$HOME/.gitconfig.local"
install -m 600 examples/ssh-config.local.example "$HOME/.ssh/config.local"
```

Edit the copies locally. Do not commit private SSH keys, access tokens, `.env` files, cloud credentials, `hosts.yml`, password-manager exports, or application databases. Git signing is enabled only by the private Git override, so a fresh clone works before an identity is configured.

## Desktop post-installation

AeroSpace starts at login and launches `borders`. Ghostty uses the `bypass` key table so Ctrl-H/J/K/L can move across both Neovim windows and Ghostty splits.

GhosttyKit requires a one-time macOS Automation permission that cannot safely be automated:

```sh
open -a Ghostty
brew services start thurstonsand/tap/ghosttykit
gty doctor
```

Approve the Automation prompt when macOS displays it. Run `aerospace reload-config` after the first AeroSpace installation. If a configuration problem occurs, consult the [AeroSpace guide](https://nikitabobko.github.io/AeroSpace/guide) and [Ghostty configuration reference](https://ghostty.org/docs/config).

## Maintenance and checks

```sh
./scripts/check.sh
brew bundle check --file Brewfile
brew bundle check --file Brewfile.desktop
```

The checks validate shell syntax, Dotbot idempotence, YAML/TOML, Brewfiles, repository paths, secrets, and Neovim startup. GitHub Actions runs the same checks on macOS. See [docs/audit.md](docs/audit.md) for the original findings, resolved issues, and intentional limitations.

When first adopting the managed AeroSpace or Ghostty configuration, `./install` moves an existing regular file or directory to a sibling named `*.dotfiles-backup.<timestamp>` before creating the symlink. Subsequent runs leave the symlink intact.

Update packages explicitly with Homebrew. Update Neovim plugins through lazy.nvim and commit the resulting `lazy-lock.json` change. Keep local identities and generated application state outside the repository.
