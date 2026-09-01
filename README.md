# mac-setup

Idempotent bootstrap for a web-dev Mac: Homebrew packages, Oh My Zsh, mise (Node + pnpm), uv (Python), and shell/git config.

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
| Terminal | Ghostty, zsh, Oh My Zsh (+ Spaceship theme + plugins below) |
| Editor | VS Code |
| Browsers | Chrome, Firefox |
| Node | mise + latest Node + pnpm 10 |
| Python | uv (installs a current Python) |
| Containers | OrbStack + Docker Desktop |
| CLI | git, gh, glab, jq, ripgrep, fd, fzf, zoxide (z), bat, eza, tree, wget, curl, watch, htop, tmux |
| Mac extras | Rectangle, Stats, AppCleaner, IINA |

### Prompt: Spaceship

[Spaceship](https://spaceship-prompt.sh) is installed as a custom Oh My Zsh theme by `scripts/install-zsh-plugins.sh`. It requires a **Nerd Font** in your terminal. Two are installed via Brewfile: `JetBrainsMono Nerd Font` and `Code New Roman Nerd Font` — set one in Ghostty's config.

### Oh My Zsh plugins

Built-in:

| Plugin | Role |
|--------|------|
| `git` | Git aliases/completions |
| `fzf` | Fuzzy finder keybindings |
| `sudo` | Double-Esc prefixes `sudo` |
| `extract` | `extract <archive>` for common formats |
| `copypath` | Copy current directory path to clipboard |
| `copyfile` | Copy file contents to clipboard |
| `copybuffer` | Copy current command line to clipboard (Ctrl+O) |
| `dirhistory` | Navigate dir history with Alt+←/→/↑ |
| `macos` | macOS helpers (`ofd`, `showfiles`, …) |
| `docker` / `docker-compose` | Completions/aliases (works with OrbStack) |
| `npm` | npm completions/shortcuts |
| `vscode` | VS Code helpers |
| `colored-man-pages` | Colorized man pages |

External (installed by `scripts/install-zsh-plugins.sh`):

| Plugin | Role |
|--------|------|
| `zsh-autosuggestions` | Ghost-text suggestions from history |
| `history-substring-search` | Up/Down search by command prefix |
| `zsh-syntax-highlighting` | Live command highlighting (loaded last) |

**Containers:** install both, but use **OrbStack** as the daily Docker runtime so it owns the `docker` CLI and you avoid socket conflicts with Docker Desktop. If `docker-desktop` fails during `brew bundle` (it needs sudo to link into `/usr/local/bin`), run `brew install --cask docker-desktop` in Terminal and enter your password, or install from the Docker website.

## Repo layout

```
Brewfile                 # Homebrew formulae + casks
install.sh               # bootstrap
config/.zprofile         # Homebrew shellenv
config/.zshrc            # Oh My Zsh + plugins + mise + aliases
config/spaceship.zsh     # Spaceship prompt config (linked to ~/.config/spaceship.zsh)
config/.gitconfig        # git defaults (work-primary identity)
scripts/macos-defaults.sh
scripts/install-zsh-plugins.sh
```

## Local secrets

Work-specific secrets and shell functions that must **not** be committed live in `~/.zshrc.optimus` (sourced automatically by `.zshrc`, never tracked by git). Back it up out-of-band — password manager, encrypted vault, or similar.

## After install

1. Restart the terminal (or open Ghostty).
2. Set git identity:

   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "you@example.com"
   ```

3. Sign into browsers / apps as needed.
