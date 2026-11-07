#!/bin/bash
set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
# Parked (kept in repo, not stowed): wezterm, tmux — add to PACKAGES to re-enable.
# claude-code only ships the status line script (~/.claude/statusline.sh). ~/.claude/settings.json
# is machine-local (Claude Code rewrites it); only its "statusLine" key is merged in below.
PACKAGES=(zsh claude-code ghostty hammerspoon zellij)

# Check stow is installed
if ! command -v stow &>/dev/null; then
  echo "stow not found — install it first: brew install stow"
  exit 1
fi

echo "=== Backing up conflicting dotfiles ==="
backup() {
  local f="$1"
  # Stow may symlink a whole parent dir (tree folding), so $f can look like a regular
  # file while actually living inside this repo. Never move those.
  local resolved
  resolved="$(cd "$(dirname "$f")" 2>/dev/null && pwd -P)/$(basename "$f")"
  [[ "$resolved" == "$DOTFILES"/* ]] && return 0
  if [[ -e "$f" && ! -L "$f" ]]; then
    echo "  Backing up $f → ${f}.backup"
    mv "$f" "${f}.backup"
  fi
}

backup ~/.zshrc
backup ~/.zprofile
backup ~/.zshenv
backup ~/.p10k.zsh
backup ~/.claude/statusline.sh
backup ~/.config/ghostty/config
backup ~/.hammerspoon/init.lua
backup ~/.config/zellij/config.kdl

echo ""
echo "=== Stowing packages ==="
cd "$DOTFILES"
mkdir -p "$HOME/.claude"   # real dir first, so stow links the file and never folds ~/.claude into the repo
for pkg in "${PACKAGES[@]}"; do
  echo "  stow $pkg"
  if [[ "$pkg" == "claude-code" ]]; then
    stow --no-folding --target="$HOME" "$pkg"
  else
    stow --target="$HOME" "$pkg"
  fi
done

echo ""
echo "=== Installing CLI tools (Zellij + Yazi file manager + preview deps) ==="
if command -v brew &>/dev/null; then
  # zellij: terminal multiplexer (auto-launched in Ghostty) · yazi: file manager · neovim: editor ($EDITOR)
  # fd/bat/eza: fuzzy-find, syntax-highlighted preview, listings
  # poppler/ffmpegthumbnailer/imagemagick/resvg: image/PDF/video/SVG previews
  # sevenzip/jq: archive + JSON previews. (fzf, ripgrep already required by zsh setup)
  # tmux: binary only, for the claude-code-sessions-manager VS Code extension (it ignores tmux.conf)
  brew install zellij yazi neovim fd bat eza poppler ffmpegthumbnailer sevenzip jq imagemagick resvg tmux
else
  echo "  brew not found — skipping. Install manually:"
  echo "  brew install zellij yazi neovim fd bat eza poppler ffmpegthumbnailer sevenzip jq imagemagick resvg tmux"
fi

echo ""
echo "=== Installing Oh My Zsh, Powerlevel10k and plugins (skipped if present) ==="
# Plain git clones — the official Oh My Zsh installer would overwrite ~/.zshrc.
ZSH_DIR="$HOME/.oh-my-zsh"
if command -v git &>/dev/null; then
  clone() { [[ -d "$2" ]] && echo "  have $(basename "$2")" || { echo "  cloning $(basename "$2")"; git clone -q --depth=1 "$1" "$2"; }; }
  clone https://github.com/ohmyzsh/ohmyzsh.git "$ZSH_DIR"
  clone https://github.com/romkatv/powerlevel10k.git "$ZSH_DIR/custom/themes/powerlevel10k"
  clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_DIR/custom/plugins/zsh-autosuggestions"
  clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_DIR/custom/plugins/zsh-syntax-highlighting"
  clone https://github.com/zsh-users/zsh-history-substring-search.git "$ZSH_DIR/custom/plugins/zsh-history-substring-search"
else
  echo "  git not found — skipping (install Xcode CLT: xcode-select --install)"
fi

echo ""
echo "=== Wiring Claude Code status line into ~/.claude/settings.json ==="
SETTINGS="$HOME/.claude/settings.json"
if ! command -v jq &>/dev/null; then
  echo "  jq not found — skipping. Add this to $SETTINGS by hand:"
  echo '  "statusLine": {"type": "command", "command": "~/.claude/statusline.sh"}'
else
  [[ -f "$SETTINGS" ]] || echo '{}' > "$SETTINGS"
  if ! jq -e . "$SETTINGS" >/dev/null 2>&1; then
    echo "  $SETTINGS is not valid JSON — leaving it alone"
  else
    updated="$(jq '.statusLine = {"type": "command", "command": "~/.claude/statusline.sh"}' "$SETTINGS")"
    if [[ "$updated" == "$(jq . "$SETTINGS")" ]]; then
      echo "  statusLine already set"
    else
      cp "$SETTINGS" "$SETTINGS.backup"
      printf '%s\n' "$updated" > "$SETTINGS"
      echo "  statusLine set (previous file saved as settings.json.backup)"
    fi
  fi
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
