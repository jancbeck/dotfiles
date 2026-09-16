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

# ls colors. CLICOLOR above turns them on for BSD ls; LSCOLORS picks the palette.
# LS_COLORS is the GNU equivalent, read by coreutils, eza, fzf and tree.
# Directories are bold blue rather than the default dim blue, which is close to
# unreadable on a dark background; other-writable dirs lose the green-on-yellow.
export LSCOLORS='ExGxFxdxCxDxDxhbadExEx'
export LS_COLORS='di=1;34:ln=1;35:so=1;32:pi=33:ex=1;31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=1;34:ow=1;34'

# Prompt: current dir, git branch with dirty/staged markers, and a prompt char
# that turns red on a non-zero exit.
#
# Not using vcs_info: it forks git several times per prompt, and on the
# ~/workspace sparsebundle each fork costs ~28ms, so a prompt in a mid-size repo
# took ~150ms. This walks up for .git and reads the branch out of HEAD with no
# fork at all, then spends a single `git status` on the dirty markers.
_git_prompt() {
  _git_prompt_msg=''
  local dir=$PWD gitdir=''
  while [[ $dir != / && -n $dir ]]; do
    [[ -e $dir/.git ]] && { gitdir=$dir/.git; break }
    dir=${dir:h}
  done
  [[ -n $gitdir ]] || return 0
  # Linked worktrees and submodules leave a `gitdir: <path>` pointer file.
  [[ -f $gitdir ]] && gitdir=${"$(<$gitdir)"#gitdir: }
  [[ -r $gitdir/HEAD ]] || return 0

  local head=${"$(<$gitdir/HEAD)"} branch
  if [[ $head == ref:* ]]; then
    branch=${head#ref: refs/heads/}
  else
    branch=${head[1,7]}   # detached HEAD
  fi

  # In-progress operation, so the prompt says why HEAD looks odd.
  local action=''
  [[ -d $gitdir/rebase-merge || -d $gitdir/rebase-apply ]] && action='|rebase'
  [[ -f $gitdir/MERGE_HEAD ]]  && action='|merge'
  [[ -f $gitdir/CHERRY_PICK_HEAD ]] && action='|cherry-pick'
  [[ -f $gitdir/BISECT_LOG ]]  && action='|bisect'

  local marks='' line
  for line in ${(f)"$(git status --porcelain --ignore-submodules 2>/dev/null)"}; do
    [[ $line == \?\?* ]] && { marks+='?'; continue }
    [[ ${line[1]} == [MADRC] ]] && marks+='+'
    [[ ${line[2]} == [MD] ]]    && marks+='*'
  done
  # Collapse to one of each, in a stable order.
  local flags=''
  [[ $marks == *'+'* ]] && flags+='+'
  [[ $marks == *'*'* ]] && flags+='*'
  [[ $marks == *'?'* ]] && flags+='?'

  _git_prompt_msg=" %F{242}(${branch}${action}${flags})%f"
  return 0
}
precmd_functions+=( _git_prompt )
setopt prompt_subst
# Collapse deep paths to .../last-three rather than wrapping the line.
PROMPT='%F{blue}%(5~|%-1~/…/%3~|%~)%f${_git_prompt_msg} %(?.%F{242}.%F{red})❯%f '

# Interactive niceties. Guarded so they no-op on machines without the formulae.
# zsh-syntax-highlighting must be sourced last — it wraps the line editor.
_zsh_plugins="$_brew_prefix/share"
[[ -r $_zsh_plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
  source $_zsh_plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ -r $_zsh_plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
  source $_zsh_plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
unset _zsh_plugins _brew_prefix
