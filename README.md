# Installation
Prior to the installation make sure you have committed the alias to your .bashrc or .zsh:
1. `alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'`
2. `curl -Lks https://git.io/vdAds | /bin/bash`

# Usage
After you've executed the setup any file within the $HOME folder can be versioned with normal commands, replacing git with your newly created config alias, like:
```
config status
config add .vimrc
config commit -m "Add vimrc"
config add .bashrc
config commit -m "Add bashrc"
config push
```

# Credits
https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/
