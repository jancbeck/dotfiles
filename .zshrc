# Skip all this init for non-interactive shells, as Claude was
# choking on this
if [[ "${-}" != *i* ]]; then
    return
fi

# Load local secrets (not tracked)
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# Start new terminals in ~/workspace
[[ "$PWD" == "$HOME" ]] && [[ -d ~/workspace ]] && cd ~/workspace

export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR='code'
export CLICOLOR=YES

alias ll='ls -la --color'

# homebrew

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  export PATH=/usr/local/bin:$PATH
fi

# homebrew end

# Load the on-disk key into the agent only when not using Secretive's enclave
# agent (which is enclave-only and rejects external keys). On Secretive machines
# the enclave handles SSH auth and commit signing.
if [[ "$SSH_AUTH_SOCK" != *Secretive* ]]; then
  if ! ssh-add -l 2>/dev/null | grep -q "id_ed25519"; then
    ssh-add --apple-use-keychain ~/.ssh/id_ed25519 2>/dev/null
  fi
fi
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=($HOME/.docker/completions $fpath)
autoload -Uz compinit
# Use the cached dump and skip the security audit when the dump already exists
# (full audit + rebuild costs ~0.5s/launch). Rebuild fully once a day.
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi
# End of Docker CLI completions

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Added by LM Studio CLI (lms)
export PATH="$PATH:$HOME/.lmstudio/bin"
