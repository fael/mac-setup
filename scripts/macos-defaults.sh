#!/usr/bin/env bash
# Safe quality-of-life macOS defaults. Idempotent; safe to re-run.
set -euo pipefail

echo "==> Applying macOS defaults..."

# Faster key repeat
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show path bar and status bar
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: list view by default
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Do not create .DS_Store on network/USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Expand save / print panels by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Dock: minimize to app icon, show indicators for open apps
defaults write com.apple.dock minimize-to-application -bool true
defaults write com.apple.dock show-process-indicators -bool true

killall Finder >/dev/null 2>&1 || true
killall Dock >/dev/null 2>&1 || true

echo "==> macOS defaults applied (some changes may need a logout/restart)."
