# Terminal Configurations

My personal terminal configuration files for zsh, wezterm, tmux, and Claude Code.

## Contents

- **zsh/** - Zsh shell configuration with Oh My Zsh and Powerlevel10k
- **wezterm/** - WezTerm terminal emulator configuration
- **tmux/** - Tmux configuration (TPM plugin manager)
- **claude-code/** - Claude Code CLI statusline configuration

## Installation

### Quick Setup

```bash
# Clone the repository
git clone https://github.com/tult/terminal-configurations.git ~/terminal-configurations

# Run the install script
cd ~/terminal-configurations
./install.sh
```

### Manual Setup

#### Zsh
```bash
# Backup existing configs
mv ~/.zshrc ~/.zshrc.backup
mv ~/.zshenv ~/.zshenv.backup
mv ~/.zprofile ~/.zprofile.backup
mv ~/.p10k.zsh ~/.p10k.zsh.backup

# Create symlinks
ln -s ~/terminal-configurations/zsh/zshrc ~/.zshrc
ln -s ~/terminal-configurations/zsh/zshenv ~/.zshenv
ln -s ~/terminal-configurations/zsh/zprofile ~/.zprofile
ln -s ~/terminal-configurations/zsh/p10k.zsh ~/.p10k.zsh

# Copy and edit the local secrets file
cp ~/terminal-configurations/zsh/zshenv.local.example ~/.zshenv.local
# Edit ~/.zshenv.local with your actual tokens
```

#### WezTerm
```bash
mkdir -p ~/.config/wezterm
ln -s ~/terminal-configurations/wezterm/wezterm.lua ~/.config/wezterm/wezterm.lua
```

#### Claude Code
```bash
mkdir -p ~/.claude
ln -s ~/terminal-configurations/claude-code/settings.json ~/.claude/settings.json
```

## Dependencies

### Zsh
- [Oh My Zsh](https://ohmyz.sh/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- [zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search)
- [zsh-shift-select](https://github.com/jirutka/zsh-shift-select)
- [fzf](https://github.com/junegunn/fzf)
- [asdf](https://asdf-vm.com/)

### WezTerm
- [JetBrainsMono Nerd Font](https://www.nerdfonts.com/font-downloads)

## Secrets

All sensitive tokens and credentials should be stored in `~/.zshenv.local` (not tracked by git).

See `zsh/zshenv.local.example` for the required environment variables.
