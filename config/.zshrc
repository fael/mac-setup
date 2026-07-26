# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git fzf)
source "$ZSH/oh-my-zsh.sh"

# fnm (Fast Node Manager)
if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --use-on-cd --shell zsh)"
fi

# Prefer eza/bat when available
if command -v eza >/dev/null 2>&1; then
  alias ls="eza"
  alias ll="eza -l"
  alias la="eza -la"
fi
if command -v bat >/dev/null 2>&1; then
  alias cat="bat --paging=never"
fi

# zoxide (z) — jump to frecent directories
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi
