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

# HOMEBREW_PREFIX is exported by `brew shellenv` in ~/.zprofile; the fallback
# covers non-login interactive shells. Avoids forking `brew --prefix` per launch.
_brew_prefix="${HOMEBREW_PREFIX:-/opt/homebrew}"
[[ -d $_brew_prefix/share/zsh-completions ]] && \
  FPATH="$_brew_prefix/share/zsh-completions:$FPATH"

case ":$PATH:" in
  *":/usr/local/bin:"*) ;;
  *) export PATH="/usr/local/bin:$PATH" ;;
esac

# homebrew end

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
[[ -d $HOME/.docker/completions ]] && fpath=($HOME/.docker/completions $fpath)
autoload -Uz compinit
# Use the cached dump and skip the security audit when it is under a day old
# (full audit + rebuild costs ~230ms/launch). Rebuild fully once a day.
# Deliberately not using a `(#qN.mh+24)` glob qualifier: that needs EXTENDED_GLOB,
# and without it the expression never expands, so the guard is always true.
zmodload -F zsh/stat b:zstat
zmodload zsh/datetime
if [[ -f ~/.zcompdump ]] && \
   (( $(zstat +mtime ~/.zcompdump) > EPOCHSECONDS - 86400 )); then
  compinit -C
else
  compinit
fi
# End of Docker CLI completions

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Added by LM Studio CLI (lms)
export PATH="$PATH:$HOME/.lmstudio/bin"

# Interactive niceties. Guarded so they no-op on machines without the formulae.
# zsh-syntax-highlighting must be sourced last — it wraps the line editor.
_zsh_plugins="$_brew_prefix/share"
[[ -r $_zsh_plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
  source $_zsh_plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ -r $_zsh_plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
  source $_zsh_plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
unset _zsh_plugins _brew_prefix
