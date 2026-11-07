# Environment variables for zsh
# NOTE: Secrets should be stored in ~/.zshenv.local (not tracked by git)

# asdf — shims in PATH for non-interactive shells and GUI apps (e.g. VS Code)
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:/opt/homebrew/bin:$PATH"

# Node options
export NODE_OPTIONS=--max-old-space-size=8192

# Machine-specific secrets and env vars (not tracked by git).
# Sourced here (not ~/.zshrc) so it also loads in non-interactive shells.
[[ -f ~/.zshenv.local ]] && source ~/.zshenv.local
