export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR='code'
export CLICOLOR=YES

alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias ll='ls -la --color'

# homebrew

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  autoload -Uz compinit
  compinit
  export PATH=/usr/local/bin:$PATH
fi

# homebrew end

export PATH="$HOME/.local/bin:$PATH"


if ! ssh-add -l | grep -q "id_ed25519"; then
  ssh-add --apple-use-keychain ~/.ssh/id_ed25519
fi
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=($HOME/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"


# Added by LM Studio CLI (lms)
export PATH="$PATH:$HOME/.lmstudio/bin"
