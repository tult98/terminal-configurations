# Terminal Configurations

Personal dotfiles for zsh, WezTerm, Ghostty, Hammerspoon, and Claude Code — managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Contents

| Package | Symlinks to |
|---|---|
| `zsh/` | `~/.zshrc`, `~/.zshenv`, `~/.zprofile`, `~/.p10k.zsh` |
| `wezterm/` | `~/.config/wezterm/wezterm.lua` |
| `ghostty/` | `~/.config/ghostty/config` |
| `hammerspoon/` | `~/.hammerspoon/init.lua` |
| `claude-code/` | `~/.claude/settings.json` |

## Quick start (new machine)

```bash
# 1. Install stow
brew install stow

# 2. Clone
git clone https://github.com/tult98/terminal-configurations ~/terminal-configurations

# 3. Install all packages
cd ~/terminal-configurations && bash install.sh

# 4. Fill in your secrets
#    ~/.zshenv.local is created from zshenv.local.example — edit it with your tokens
```

## Syncing changes

Dotfiles in `~` are symlinks into the repo, so edits take effect immediately. To sync to another machine:

```bash
# On the machine you edited
git add . && git commit -m "..." && git push

# On the other machine
cd ~/terminal-configurations && git pull
# No re-stowing needed — symlinks already point to the repo
```

## Secrets

All tokens and credentials go in `~/.zshenv.local` — it is **not tracked by git**.

See [`zshenv.local.example`](./zshenv.local.example) for the full list of expected variables. Sourced at the end of `.zshrc`.

## Dependencies

Install these before or after running `install.sh`:

**Zsh**
- [Oh My Zsh](https://ohmyz.sh/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- [zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search)
- [fzf](https://github.com/junegunn/fzf)
- [asdf](https://asdf-vm.com/)
- [pyenv](https://github.com/pyenv/pyenv)

**WezTerm**
- [JetBrainsMono Nerd Font](https://www.nerdfonts.com/font-downloads)
