# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="spaceship"

# Built-in + custom plugins. zsh-syntax-highlighting must stay last.
plugins=(
  git
  fzf
  sudo
  extract
  copypath
  copyfile
  copybuffer
  dirhistory
  macos
  docker
  docker-compose
  npm
  vscode
  colored-man-pages
  zsh-autosuggestions
  history-substring-search
  zsh-syntax-highlighting
)

source "$ZSH/oh-my-zsh.sh"

# history-substring-search: Up/Down match prefix
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down

# mise (runtime manager for Node, pnpm, etc.)
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

_restore_cargo_path() {
  [[ ":$PATH:" == *":$HOME/.cargo/bin:"* ]] || export PATH="$HOME/.cargo/bin:$PATH"
}
add-zsh-hook chpwd _restore_cargo_path
add-zsh-hook precmd _restore_cargo_path

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

# Tab completion: show menu and navigate with arrow keys
zstyle ':completion:*' menu select
# Autosuggestions: validate paths so only existing dirs are suggested
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Shortcuts
alias c="clear"
alias p="pnpm"

# Optimus work config (not tracked — see ~/.zshrc.optimus)
[ -f "$HOME/.zshrc.optimus" ] && source "$HOME/.zshrc.optimus"


# Pick and run a package.json script (pnpm)
s() {
  if [[ ! -f package.json ]]; then
    echo "No package.json in $(pwd)"
    return 1
  fi

  local deps=(jq fzf awk sed xargs)
  local cmd
  for cmd in "${deps[@]}"; do
    if ! command -v "$cmd" >/dev/null; then
      echo "Missing dependency: $cmd"
      return 1
    fi
  done

  if ! command -v pnpm >/dev/null; then
    echo "pnpm not found (install via mise: mise use -g pnpm@10)"
    return 1
  fi

  jq -r '.scripts | to_entries[] | .key + ": " + .value' package.json |
    fzf --exact --ansi --prompt="Select a script: " --header="↑↓ navigate, type to filter" |
    awk -F': ' '{print $1}' |
    xargs -I {} pnpm run {}
}

# GPG signing in terminal
export GPG_TTY=$(tty)

alias tq="utoqan"
alias ai="ia"

