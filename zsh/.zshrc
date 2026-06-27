# ── Zellij auto-launch (Ghostty only) ────────────────────────────────────────
# Drop straight into the shared "main" Zellij session when opening Ghostty.
# Guarded so a missing zellij binary can't break the shell. Inside Zellij,
# Ctrl+y is handled by Zellij's keybind (floating Yazi pane, works in any app);
# outside it, the _yazi_cd widget below handles Ctrl+y (cwd-on-exit at the
# shell prompt).
if [[ "$TERM_PROGRAM" == "ghostty" && -z "$ZELLIJ" ]] && command -v zellij &>/dev/null; then
  exec zellij attach -c main
fi

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

source $ZSH/oh-my-zsh.sh

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

# PostgreSQL — hardcoded Cellar path; replace with asdf or `brew link postgresql@15` if it breaks
export PATH="/opt/homebrew/Cellar/postgresql@15/15.13/bin:$PATH"

# Go
export PATH="$PATH:/Users/tult/go/bin"

# Local bin, eh-dev, flashlight
export PATH="$PATH:$HOME/.local/bin"
export PATH="$HOME/.eh-dev/bin:$PATH"
export PATH="/Users/tult/.flashlight/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/tult/Library/pnpm"
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

# asdf — multi-language version manager
. "/opt/homebrew/opt/asdf/libexec/asdf.sh"
fpath=(${ASDF_DIR}/completions $fpath)
autoload -Uz compinit && compinit

# ── React Native / Android ────────────────────────────────────────────────────
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home
export JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF-8"
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

# ── Employment Hero ───────────────────────────────────────────────────────────
# Disables Rails Spring pre-loader for more predictable boot times
export DISABLE_SPRING=true
# ws CLI shell integration (workspace tab-completion and env setup)
command -v ws >/dev/null 2>&1 && eval "$(ws shell-init)"

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
# aikido-endpoint-cert-config-start
# Allow Node.js tooling to trust the SafeChain MITM CA while preserving public roots.
[[ -f "/Library/Application Support/AikidoSecurity/EndpointProtection/run/endpoint-protection-combined-ca.pem" ]] && \
  export NODE_EXTRA_CA_CERTS="/Library/Application Support/AikidoSecurity/EndpointProtection/run/endpoint-protection-combined-ca.pem"
# aikido-endpoint-cert-config-end
# aikido-endpoint-pip-cert-config-start
# Allow Python package managers to trust the SafeChain MITM CA while preserving user-provided roots.
if [[ -f "/Library/Application Support/AikidoSecurity/EndpointProtection/run/endpoint-protection-pip-combined-ca.pem" ]]; then
  export PIP_CERT="/Library/Application Support/AikidoSecurity/EndpointProtection/run/endpoint-protection-pip-combined-ca.pem"
  export REQUESTS_CA_BUNDLE="/Library/Application Support/AikidoSecurity/EndpointProtection/run/endpoint-protection-pip-combined-ca.pem"
  export POETRY_CERTIFICATES_PYPI_CERT="/Library/Application Support/AikidoSecurity/EndpointProtection/run/endpoint-protection-pip-combined-ca.pem"
fi
export UV_SYSTEM_CERTS=true
# aikido-endpoint-pip-cert-config-end
# aikido-endpoint-ruby-cert-config-start
# Allow Ruby Bundler to trust the SafeChain MITM CA while preserving public roots.
[[ -f "/Library/Application Support/AikidoSecurity/EndpointProtection/run/endpoint-protection-ruby-combined-ca.pem" ]] && \
  export BUNDLE_SSL_CA_CERT="/Library/Application Support/AikidoSecurity/EndpointProtection/run/endpoint-protection-ruby-combined-ca.pem"
# aikido-endpoint-ruby-cert-config-end
# aikido-endpoint-curl-cert-config-start
# Allow curl and other OpenSSL-linked tools to trust the SafeChain MITM CA while preserving the system roots.
[[ -f "/Library/Application Support/AikidoSecurity/EndpointProtection/run/endpoint-protection-openssl-combined-ca.pem" ]] && \
  export CURL_CA_BUNDLE="/Library/Application Support/AikidoSecurity/EndpointProtection/run/endpoint-protection-openssl-combined-ca.pem"
# aikido-endpoint-curl-cert-config-end
