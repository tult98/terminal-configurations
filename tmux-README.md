# tmux Configuration (parked)

`tmux/.config/tmux/tmux.conf` is kept for future use but is **not stowed** by `install.sh`.

The `tmux` binary is still installed by `install.sh` because the
[claude-code-sessions-manager](https://github.com/tult98/claude-code-sessions-manager) VS Code
extension hosts sessions in its own private tmux server. That server never loads
`~/.tmux.conf`, so this config has no effect on it.

## Re-enable

1. Add `tmux` to `PACKAGES` in `install.sh` and a matching `backup ~/.config/tmux/tmux.conf` line
   (or `~/.tmux.conf`, depending on how you want tmux to find it).
2. Install TPM if you want plugins:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```
