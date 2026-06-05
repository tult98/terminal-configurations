#!/bin/bash
set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES=(zsh wezterm claude-code ghostty hammerspoon zellij)

# Check stow is installed
if ! command -v stow &>/dev/null; then
  echo "stow not found — install it first: brew install stow"
  exit 1
fi

echo "=== Backing up conflicting dotfiles ==="
backup() {
  local f="$1"
  if [[ -e "$f" && ! -L "$f" ]]; then
    echo "  Backing up $f → ${f}.backup"
    mv "$f" "${f}.backup"
  fi
}

backup ~/.zshrc
backup ~/.zprofile
backup ~/.zshenv
backup ~/.p10k.zsh
backup ~/.config/wezterm/wezterm.lua
backup ~/.claude/settings.json
backup ~/.config/ghostty/config
backup ~/.config/zellij/config.kdl
backup ~/.hammerspoon/init.lua

echo ""
echo "=== Stowing packages ==="
cd "$DOTFILES"
for pkg in "${PACKAGES[@]}"; do
  echo "  stow $pkg"
  stow "$pkg"
done

echo ""
echo "=== Setting up local secrets ==="
if [[ ! -f "$HOME/.zshenv.local" ]]; then
  echo "  Creating ~/.zshenv.local from example — fill in your tokens!"
  cp "$DOTFILES/zshenv.local.example" "$HOME/.zshenv.local"
else
  echo "  ~/.zshenv.local already exists, skipping"
fi

echo ""
echo "=== Done! Restart your terminal to apply changes. ==="
