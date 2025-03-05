alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
eval "$(/opt/homebrew/bin/brew shellenv)"

# tabtab source for electron-forge package
# uninstall by removing these lines or running `tabtab uninstall electron-forge`
[[ -f /opt/homebrew/lib/node_modules/electron-forge/node_modules/tabtab/.completions/electron-forge.zsh ]] && . /opt/homebrew/lib/node_modules/electron-forge/node_modules/tabtab/.completions/electron-forge.zsh
# pnpm
export PNPM_HOME="/Users/jan/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end


# Created by `pipx` on 2024-03-05 14:47:47
export PATH="$PATH:/Users/jan/.local/bin"

eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"

# bun completions
[ -s "/Users/jan/.bun/_bun" ] && source "/Users/jan/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

#nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

ln -sf "$(which node)" "$HOME/.local/bin/node"
