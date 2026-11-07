# Terminal Configurations

Personal dotfiles for zsh, Ghostty, Zellij, Hammerspoon, and Claude Code — managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Contents

| Package | Symlinks to |
|---|---|
| `zsh/` | `~/.zshrc`, `~/.zshenv`, `~/.zprofile`, `~/.p10k.zsh` |
| `ghostty/` | `~/.config/ghostty/config` |
| `hammerspoon/` | `~/.hammerspoon/init.lua` |
| `claude-code/` | `~/.claude/statusline.sh` only. `install.sh` merges the `statusLine` key into your `~/.claude/settings.json` and leaves every other setting alone |
| `zellij/` | `~/.config/zellij/config.kdl` |

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

See [`zshenv.local.example`](./zshenv.local.example). Sourced from `.zshenv`, so it loads in every zsh shell.

## Work machine (Employment Hero)

Work-only config is **not** in this repo. It lives in a separate private repo, `eh-dotfiles`
(`~/.zshrc.work`, the EH Claude plugin overlay, EH token names). On a work machine, run this repo's
`install.sh` first, then `eh-dotfiles/install.sh`. `.zshrc` ends with
`[[ -r ~/.zshrc.work ]] && source ~/.zshrc.work`, so personal machines need nothing extra.

## Dependencies

Install these before or after running `install.sh`:

**Zsh**
- [Oh My Zsh](https://ohmyz.sh/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- [zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search)
- [asdf](https://asdf-vm.com/)
- [pyenv](https://github.com/pyenv/pyenv)

**Fonts**
- [JetBrainsMono Nerd Font](https://www.nerdfonts.com/font-downloads)

**tmux** (binary only — installed by `install.sh`)
- Used by the [claude-code-sessions-manager](https://github.com/tult98/claude-code-sessions-manager) VS Code extension, which runs its own private tmux server and never loads `tmux.conf`.

**Parked packages** (kept in the repo, *not* stowed by `install.sh`)
- `wezterm/` and `tmux/` — not in daily use. To re-enable, add the package name to `PACKAGES` in `install.sh`
  (and `backup` its target path); for WezTerm also install the font above.

**Zellij + Yazi** (terminal multiplexer + file manager — installed by `install.sh` via Homebrew)
- `zellij` `yazi` `fd` `bat` `eza` `poppler` `ffmpegthumbnailer` `sevenzip` `jq` `imagemagick` `resvg`

[Zellij](https://zellij.dev/) auto-launches in Ghostty — every new window attaches to the
shared `main` session (see the guard at the top of `.zshrc`). Press **Ctrl+y** inside Zellij
to pop [Yazi](https://yazi-rs.github.io/) up in a **floating pane**; quit Yazi with `q` and the
pane closes. Outside Zellij, **Ctrl+y** falls back to full-window Yazi that `cd`s the shell to
wherever you quit. Yazi runs on its stock defaults — press `~` (or `F1`) inside for the full
keybinding list; the preview deps above power its image/PDF/video/archive previews.
