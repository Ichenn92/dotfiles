# Repository audit

Audit date: 2026-08-26

## Initial structure

The repository used Dotbot 1.20.1 as a Git submodule to link root-level Zsh, Git, SSH, and Powerlevel10k files plus the `config/nvim` tree. Neovim was the only XDG application committed. There was no README, ignore policy, Homebrew manifest, automated validation, or reproducible macOS desktop setup.

The working tree already contained uncommitted Neovim changes when this audit began. Those changes are user-owned and were preserved; targeted fixes were applied without a global formatting pass.

## Findings and resolutions

| Finding | Resolution |
| --- | --- |
| Git name, email, signing key, and a host-specific SSH identity were tracked | Moved to private `~/.gitconfig.local` and `~/.ssh/config.local`; neutral examples are tracked |
| Absolute home-directory paths appeared in Zsh, ast-grep, and Ghostty files | Replaced with `$HOME`, Homebrew prefix discovery, or paths relative to the application config |
| `.DS_Store` files were tracked | Removed and ignored recursively |
| `sgconfig.yml` referenced directories that did not exist | Removed the dead configuration |
| Homebrew dependencies were implicit | Added separate baseline and optional desktop Brewfiles |
| AeroSpace and Ghostty configuration existed only on the current machine | Imported, made portable, and linked through Dotbot |
| GhosttyKit used a key table name inconsistent with the installed toolkit documentation | Standardized Ghostty and Neovim on `bypass` |
| Zsh initialization duplicated PATH, Dart, pipx, Bun, and Cargo setup | Consolidated and guarded optional tools |
| `kill_port` immediately used SIGKILL and accepted invalid input | Added port validation, SIGTERM waiting, and SIGKILL fallback |
| Neovim used an incorrect netrw flag and deprecated APIs | Corrected the flag and updated only the affected calls |
| Neovim referenced `shfmt`, but the command was not installed | Added `shfmt` to the baseline Brewfile |
| No repeatable validation existed | Added a local checker and a macOS GitHub Actions workflow |

## Sensitive-data review

A repository and history pattern scan found no private key block, API token, or obvious password. The initial tracked identity data was personally identifying and machine-specific even though a GPG key ID and an SSH key filename are not private keys. The public configuration now contains no real identity or absolute user home path.

Gitleaks is used as a guardrail, not as proof that every possible secret is absent. Review staged changes before pushing and rotate any credential immediately if it is ever committed.

## Intentional limitations

- The Brewfiles restore declared software, not application preferences, licenses, sessions, or user data.
- macOS Accessibility and Automation permissions require explicit user approval.
- Language versions managed by NVM or rbenv remain project/user choices and are not installed automatically.
- Browsers, VPNs, chat applications, cloud credentials, and personal productivity applications are outside the public manifest.
- The bootstrap installs and links configuration but never removes unrelated Homebrew packages.
