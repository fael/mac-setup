# mac-setup

Idempotent bootstrap for a web-dev Mac: Homebrew packages, Oh My Zsh, fnm (Node), uv (Python), and shell/git config.

## One-command install

```bash
cd ~/Projects/mac-setup
./install.sh
```

Skip macOS preference tweaks:

```bash
SKIP_MACOS_DEFAULTS=1 ./install.sh
```

Safe to re-run; existing configs are backed up before symlinking.

## What’s included

| Area | Tools |
|------|--------|
| Terminal | Ghostty, zsh, Oh My Zsh |
| Editor | VS Code |
| Browsers | Chrome, Chromium, Firefox |
| Node | fnm + LTS Node |
| Python | uv (installs a current Python) |
| Containers | OrbStack + Docker Desktop |
| CLI | git, jq, ripgrep, fd, fzf, bat, eza, tree, wget, curl, watch, htop, tmux |
| Mac extras | Rectangle, Stats, AppCleaner, IINA |

**Containers:** install both, but use **OrbStack** as the daily Docker runtime so it owns the `docker` CLI and you avoid socket conflicts with Docker Desktop. If `docker-desktop` fails during `brew bundle` (it needs sudo to link into `/usr/local/bin`), run `brew install --cask docker-desktop` in Terminal and enter your password, or install from the Docker website.

## Repo layout

```
Brewfile                 # Homebrew formulae + casks
install.sh               # bootstrap
config/.zprofile         # Homebrew shellenv
config/.zshrc            # Oh My Zsh + fnm + aliases
config/.gitconfig        # git defaults (no user.name/email)
scripts/macos-defaults.sh
```

## After install

1. Restart the terminal (or open Ghostty).
2. Set git identity:

   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "you@example.com"
   ```

3. Sign into browsers / apps as needed.

## Push to GitHub later

Create an empty repo on GitHub, then:

```bash
git remote add origin git@github.com:<you>/mac-setup.git
git push -u origin main
```
