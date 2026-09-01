#!/usr/bin/env bash
# Idempotent install of Oh My Zsh custom plugins (zsh-users).
set -euo pipefail

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
PLUGIN_DIR="$ZSH_CUSTOM/plugins"

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Oh My Zsh not found at ~/.oh-my-zsh; skip custom plugins."
  exit 0
fi

mkdir -p "$PLUGIN_DIR"

clone_plugin() {
  local name="$1"
  local repo="$2"
  local dest="$PLUGIN_DIR/$name"
  if [ -d "$dest/.git" ]; then
    echo "    already installed: $name"
    return 0
  fi
  if [ -d "$dest" ]; then
    echo "    replacing non-git dir: $name"
    rm -rf "$dest"
  fi
  echo "    cloning: $name"
  git clone --depth=1 "$repo" "$dest"
}

echo "==> Installing Oh My Zsh custom plugins..."
clone_plugin zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions.git
clone_plugin zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting.git
clone_plugin history-substring-search https://github.com/zsh-users/zsh-history-substring-search.git
echo "==> Custom zsh plugins ready."

# Spaceship theme
THEME_DIR="$ZSH_CUSTOM/themes"
SPACESHIP_DIR="$THEME_DIR/spaceship-prompt"
SPACESHIP_LINK="$THEME_DIR/spaceship.zsh-theme"

mkdir -p "$THEME_DIR"

if [ -d "$SPACESHIP_DIR/.git" ]; then
  echo "    already installed: spaceship"
else
  if [ -d "$SPACESHIP_DIR" ]; then
    rm -rf "$SPACESHIP_DIR"
  fi
  echo "    cloning: spaceship-prompt"
  git clone --depth=1 https://github.com/spaceship-prompt/spaceship-prompt.git "$SPACESHIP_DIR"
fi

if [ ! -L "$SPACESHIP_LINK" ]; then
  ln -s "$SPACESHIP_DIR/spaceship.zsh-theme" "$SPACESHIP_LINK"
  echo "    linked: spaceship.zsh-theme"
fi

echo "==> Spaceship theme ready."
