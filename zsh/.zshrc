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
PATH=$(pyenv root)/shims:$PATH

# asdf — multi-language version manager
. "/opt/homebrew/opt/asdf/libexec/asdf.sh"
fpath=(${ASDF_DIR}/completions $fpath)
autoload -Uz compinit && compinit

# fzf — fuzzy finder key bindings and completion
eval "$(fzf --zsh)"

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
eval "$(ws shell-init)"

# ── Prompt & local overrides ──────────────────────────────────────────────────
# p10k theme config — run `p10k configure` to regenerate ~/.p10k.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# Machine-specific secrets and env vars (not tracked by git — see zshenv.local.example)
[[ -f ~/.zshenv.local ]] && source ~/.zshenv.local
