# Environment variables for zsh
# NOTE: Secrets should be stored in ~/.zshenv.local (not tracked by git)

# Node options
export NODE_OPTIONS=--max-old-space-size=8192

# MeaWallet config (set actual values in ~/.zshenv.local)
# export MEAWALLET_USERNAME=<your-username>
# export MEAWALLET_PASSWORD=<your-password>
# export MEAWALLET_ENV=test

# NPM tokens (set actual values in ~/.zshenv.local)
# export EH_MARKETING_UI_NPM_TOKEN=<your-token>
# export EWALLET_NPM_TOKEN=<your-token>
# export EH_NPM_TOKEN=<your-token>

# Bundle/Gem credentials (set actual values in ~/.zshenv.local)
# export BUNDLE_GEMS__CONTRIBSYS__COM=<your-credentials>
# export BUNDLE_GEM__FURY__IO=<your-credentials>

# Atlassian API (set actual values in ~/.zshenv.local)
# export ATLASSIAN_API_TOKEN=<your-token>

# GitHub tokens (set actual values in ~/.zshenv.local)
# export EH_GITHUB_PKG_TOKEN=<your-token>
# export REVIEWDOG_GITHUB_API_TOKEN=<your-token>
# export DANGER_GITHUB_API_TOKEN=<your-token>
# export GITHUB_TOKEN=<your-token>

# GitLab tokens (set actual values in ~/.zshenv.local)
# export GITLAB_TOKEN=<your-token>  # read_package_registry scope; installs @ceartas/ui

# Machine-specific secrets and env vars (not tracked by git).
# Sourced here (not ~/.zshrc) so it also loads in non-interactive shells.
[[ -f ~/.zshenv.local ]] && source ~/.zshenv.local
