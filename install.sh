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
backup ~/.hammerspoon/init.lua
backup ~/.config/zellij/config.kdl

echo ""
echo "=== Stowing packages ==="
cd "$DOTFILES"
for pkg in "${PACKAGES[@]}"; do
  echo "  stow $pkg"
  stow "$pkg"
done

echo ""
echo "=== Installing CLI tools (Zellij + Yazi file manager + preview deps) ==="
if command -v brew &>/dev/null; then
  # zellij: terminal multiplexer (auto-launched in Ghostty) · yazi: file manager · neovim: editor ($EDITOR)
  # fd/bat/eza: fuzzy-find, syntax-highlighted preview, listings
  # poppler/ffmpegthumbnailer/imagemagick/resvg: image/PDF/video/SVG previews
  # sevenzip/jq: archive + JSON previews. (fzf, ripgrep already required by zsh setup)
  brew install zellij yazi neovim fd bat eza poppler ffmpegthumbnailer sevenzip jq imagemagick resvg
else
  echo "  brew not found — skipping. Install manually:"
  echo "  brew install zellij yazi neovim fd bat eza poppler ffmpegthumbnailer sevenzip jq imagemagick resvg"
fi

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
