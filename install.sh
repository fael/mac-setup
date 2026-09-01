#!/usr/bin/env bash
# Idempotent macOS web-dev bootstrap for this repo.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$ROOT/config"

link_file() {
  local src="$1"
  local dest="$2"
  if [ -L "$dest" ]; then
    local current
    current="$(readlink "$dest")"
    if [ "$current" = "$src" ]; then
      echo "    already linked: $dest"
      return 0
    fi
    rm "$dest"
  elif [ -e "$dest" ]; then
    local backup="${dest}.bak.$(date +%Y%m%d%H%M%S)"
    echo "    backing up $dest -> $backup"
    mv "$dest" "$backup"
  fi
  ln -s "$src" "$dest"
  echo "    linked: $dest -> $src"
}

echo "==> mac-setup bootstrap"
echo "    repo: $ROOT"

# 0. Xcode Command Line Tools
if ! xcode-select -p &>/dev/null; then
  echo "==> Installing Xcode Command Line Tools..."
  xcode-select --install
  echo "    A dialog has opened — complete the installation, then re-run this script."
  exit 1
else
  echo "==> Xcode Command Line Tools already installed"
fi

# 1. Homebrew
if ! command -v brew >/dev/null 2>&1; then
  echo "==> Installing Homebrew..."
  # Avoid NONINTERACTIVE so sudo can prompt for a password in Terminal.
  # Unset any inherited NONINTERACTIVE from parent environments.
  env -u NONINTERACTIVE /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
else
  echo "==> Homebrew already installed"
  eval "$(brew shellenv)"
fi

# 2. Brewfile
echo "==> Installing Brewfile packages..."
if ! brew bundle --file="$ROOT/Brewfile"; then
  echo "==> Warning: brew bundle reported one or more failures; continuing."
  echo "    (Docker Desktop often needs sudo to link binaries into /usr/local/bin —"
  echo "     install/repair it manually later if it failed.)"
fi

# 3. Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "==> Installing Oh My Zsh..."
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "==> Oh My Zsh already installed"
fi

# 3b. Custom Oh My Zsh plugins (autosuggestions, syntax highlighting, …)
bash "$ROOT/scripts/install-zsh-plugins.sh"

# 4. Symlink configs
echo "==> Linking config files..."
link_file "$CONFIG_DIR/.zprofile" "$HOME/.zprofile"
link_file "$CONFIG_DIR/.zshrc" "$HOME/.zshrc"
link_file "$CONFIG_DIR/.gitconfig" "$HOME/.gitconfig"
mkdir -p "$HOME/.config/ghostty"
link_file "$CONFIG_DIR/spaceship.zsh" "$HOME/.config/spaceship.zsh"
link_file "$CONFIG_DIR/ghostty" "$HOME/.config/ghostty/config"

# Ensure Homebrew is on PATH for the rest of this script (fresh shells use .zprofile)
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# 5. Node + pnpm via mise
echo "==> Installing Node + pnpm via mise..."
eval "$(mise activate bash)"
mise use -g node@latest pnpm@10
mise install

# 6. Python via uv
echo "==> Installing Python (uv)..."
uv python install

# 7. Optional macOS defaults
if [ "${SKIP_MACOS_DEFAULTS:-}" != "1" ]; then
  echo "==> Running macos-defaults.sh (set SKIP_MACOS_DEFAULTS=1 to skip)..."
  bash "$ROOT/scripts/macos-defaults.sh"
else
  echo "==> Skipping macos-defaults.sh"
fi

echo
echo "==> Done."
echo
echo "Next steps:"
echo "  1. Restart your terminal (or open Ghostty) so shell config loads."
echo "  2. Set your git identity:"
echo "       git config --global user.name \"Your Name\""
echo "       git config --global user.email \"you@example.com\""
echo "  3. Sign in to Chrome / Firefox as needed."
echo "  4. Prefer OrbStack for Docker day-to-day (avoids Docker Desktop socket conflicts)."
echo "  5. When ready to push this repo, create it on GitHub then:"
echo "       git remote add origin git@github.com:<you>/mac-setup.git"
echo "       git push -u origin main"
echo
echo "Versions:"
command -v brew >/dev/null && brew --version | head -1 || true
command -v git >/dev/null && git --version || true
command -v mise >/dev/null && mise --version || true
command -v node >/dev/null && node --version || true
command -v pnpm >/dev/null && pnpm --version || true
command -v uv >/dev/null && uv --version || true
command -v python3 >/dev/null && python3 --version || true
