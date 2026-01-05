#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing terminal configurations..."

# Backup and link zsh configs
backup_and_link() {
    local src=$1
    local dest=$2

    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
        echo "Backing up $dest to ${dest}.backup"
        mv "$dest" "${dest}.backup"
    elif [ -L "$dest" ]; then
        rm "$dest"
    fi

    echo "Linking $src -> $dest"
    ln -s "$src" "$dest"
}

echo ""
echo "=== Zsh Configuration ==="
backup_and_link "$SCRIPT_DIR/zsh/zshrc" "$HOME/.zshrc"
backup_and_link "$SCRIPT_DIR/zsh/zshenv" "$HOME/.zshenv"
backup_and_link "$SCRIPT_DIR/zsh/zprofile" "$HOME/.zprofile"
backup_and_link "$SCRIPT_DIR/zsh/p10k.zsh" "$HOME/.p10k.zsh"

# Handle local secrets file
if [ ! -f "$HOME/.zshenv.local" ]; then
    echo "Creating ~/.zshenv.local from example..."
    cp "$SCRIPT_DIR/zsh/zshenv.local.example" "$HOME/.zshenv.local"
    echo "WARNING: Please edit ~/.zshenv.local and add your actual tokens!"
fi

echo ""
echo "=== WezTerm Configuration ==="
mkdir -p "$HOME/.config/wezterm"
backup_and_link "$SCRIPT_DIR/wezterm/wezterm.lua" "$HOME/.config/wezterm/wezterm.lua"

echo ""
echo "=== Claude Code Configuration ==="
mkdir -p "$HOME/.claude"
backup_and_link "$SCRIPT_DIR/claude-code/settings.json" "$HOME/.claude/settings.json"

echo ""
echo "=== Installation Complete ==="
echo ""
echo "Don't forget to:"
echo "1. Edit ~/.zshenv.local with your actual tokens"
echo "2. Install Oh My Zsh: sh -c \"\$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\""
echo "3. Install Powerlevel10k: git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \${ZSH_CUSTOM:-\$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
echo "4. Install zsh plugins (see README.md)"
echo "5. Install JetBrainsMono Nerd Font for WezTerm"
echo ""
echo "Restart your terminal to apply changes."
