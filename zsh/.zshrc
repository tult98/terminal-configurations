# ── Zellij auto-launch (Ghostty only) ────────────────────────────────────────
# Drop straight into the shared "main" Zellij session when opening Ghostty.
# Guarded so a missing zellij binary can't break the shell. Inside Zellij,
# Ctrl+y is handled by Zellij's keybind (floating Yazi pane, works in any app);
# outside it, the _yazi_cd widget below handles Ctrl+y (cwd-on-exit at the
# shell prompt).
# if [[ "$TERM_PROGRAM" == "ghostty" && -z "$ZELLIJ" ]] && command -v zellij &>/dev/null; then
#   exec zellij attach -c main
# fi

# ── Powerlevel10k instant prompt ─────────────────────────────────────────────
# Must be at top before any output to enable the instant prompt feature
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ── Oh-My-Zsh ────────────────────────────────────────────────────────────────
# Shell framework — theme, plugins, completions
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  node
  npm
  yarn
  web-search
  urltools
  jsontools
  copypath
  extract
  command-not-found
  colored-man-pages
  z
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-history-substring-search
)

[[ -r $ZSH/oh-my-zsh.sh ]] && source $ZSH/oh-my-zsh.sh   # installed by install.sh

# ── Key bindings ──────────────────────────────────────────────────────────────
# Arrow keys navigate history filtered by current input (requires zsh-history-substring-search)
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Word jump — Option+arrows / Option+b/f move cursor by word
bindkey '^[[1;3D' backward-word        # Option+Left
bindkey '^[[1;3C' forward-word         # Option+Right
bindkey '^[b'     backward-word        # Option+b
bindkey '^[f'     forward-word         # Option+f

# Visual word selection — Shift+Option+Arrow extends a highlighted region by word.
# Backspace deletes the region if active, otherwise deletes one char.
zle_highlight=(region:standout)

function _select-backward-word() {
  (( REGION_ACTIVE )) || zle set-mark-command
  zle backward-word
}
zle -N _select-backward-word

function _select-forward-word() {
  (( REGION_ACTIVE )) || zle set-mark-command
  zle forward-word
}
zle -N _select-forward-word

function _delete-or-kill-region() {
  if (( REGION_ACTIVE )); then
    zle kill-region
  else
    zle backward-delete-char
  fi
}
zle -N _delete-or-kill-region

bindkey '^[[1;4D' _select-backward-word   # Shift+Option+Left
bindkey '^[[1;4C' _select-forward-word    # Shift+Option+Right
bindkey '^?'      _delete-or-kill-region  # Backspace → delete region or char
bindkey '^[^?'    backward-kill-word      # Option+Backspace → delete word (no select)

# ── PATH ──────────────────────────────────────────────────────────────────────
# Core system paths
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/usr/local/bin:$PATH"

# Java (OpenJDK via Homebrew)
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

# LLVM
export PATH="/opt/homebrew/opt/llvm@16/bin:$PATH"

# PostgreSQL — version-pinned Cellar path; only added if present
[[ -d /opt/homebrew/Cellar/postgresql@15/15.13/bin ]] && export PATH="/opt/homebrew/Cellar/postgresql@15/15.13/bin:$PATH"

# Go
[[ -d "$HOME/go/bin" ]] && export PATH="$PATH:$HOME/go/bin"

# Local bin, flashlight
export PATH="$PATH:$HOME/.local/bin"
[[ -d "$HOME/.flashlight/bin" ]] && export PATH="$HOME/.flashlight/bin:$PATH"

# ── Headroom (token-optimization proxy for Claude Code) ───────────────────────
# `headroom` CLI lives in the Python 3.14 framework bin. The proxy is OPT-IN:
# exporting ANTHROPIC_BASE_URL globally makes Claude Code refuse Remote Control
# ("only available when using Claude via api.anthropic.com"), so route through it
# per-command instead:   hr claude      (or: hr claude --resume)
# Verify the proxy is up with: curl -fsS http://localhost:8787/health
[[ -d /Library/Frameworks/Python.framework/Versions/3.14/bin ]] && export PATH="/Library/Frameworks/Python.framework/Versions/3.14/bin:$PATH"
hr() { ANTHROPIC_BASE_URL="http://localhost:8787" "$@"; }

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# ── Tool setup ────────────────────────────────────────────────────────────────
# Version managers and CLI tools that need shell integration

# pyenv — python version shims
if command -v pyenv >/dev/null 2>&1; then
  PATH=$(pyenv root)/shims:$PATH
fi

# rbenv — Ruby version manager
command -v rbenv >/dev/null 2>&1 && eval "$(rbenv init - zsh)"
autoload -Uz compinit && compinit

# ── React Native / Android ────────────────────────────────────────────────────
[[ -d /Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home ]] && export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home
export JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF-8"
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Default editor: Neovim (modal). Used by Yazi (Enter on a file), git commits,
# `kubectl edit`, etc. — all in the terminal. If you get stuck: Esc → :wq saves &
# quits, :q! quits without saving. Run `nvim` then `:Tutor` for the built-in lessons.
export EDITOR="nvim"
export VISUAL="nvim"

# ── Yazi launcher (non-Zellij fallback) ───────────────────────────────────────
# Inside Zellij, Ctrl+Y is handled by Zellij's keybind (floating Yazi pane, see
# zellij/.config/zellij/config.kdl) so it works in any app, not just at the
# prompt. This widget only fires OUTSIDE Zellij: it opens Yazi (stock config)
# and cd's the shell to wherever you quit — the standard cwd-on-exit wrapper from
# the Yazi docs. Bound to a key to dodge the oh-my-zsh yarn plugin's `y`/`yy`
# aliases. (Default Ctrl+Y is yank/paste.)
function _yazi_cd() {
  local tmp cwd
  tmp="$(mktemp -t yazi-cwd.XXXXXX)"
  yazi --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
  zle reset-prompt
}
zle -N _yazi_cd
bindkey '^Y' _yazi_cd

# ── Prompt & local overrides ──────────────────────────────────────────────────
# p10k theme config — run `p10k configure` to regenerate ~/.p10k.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# Machine-specific secrets/env vars are now sourced from ~/.zshenv (loads in
# non-interactive shells too), so no longer sourced here.
# >>> headroom persistent env >>>
export HEADROOM_PORT="8787"
export HEADROOM_HOST="127.0.0.1"
export HEADROOM_MODE="token"
export HEADROOM_BACKEND="anthropic"
export HEADROOM_TELEMETRY="off"
# <<< headroom persistent env <<<

# ── Work overlay (optional) ───────────────────────────────────────────────────
# ~/.zshrc.work comes from the private eh-dotfiles repo; absent on personal machines.
[[ -r ~/.zshrc.work ]] && source ~/.zshrc.work
