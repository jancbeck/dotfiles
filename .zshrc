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
