# MacOS Dotfiles & Config

The technique consists in storing a Git bare repository in a "side" folder (like `$HOME/.cfg` or `$HOME/.myconfig`) using a specially crafted alias so that commands are run against that repository and not the usual `.git` local folder, which would interfere with any other Git repositories around.

## Installation

Prior to the installation make sure you have committed the alias to your `.zshrc`:

```bash
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
```

Now clone your dotfiles into a bare repository in a "dot" folder of your

`$HOME`:

```bash
git clone --bare https://github.com/jancbeck/dotfiles $HOME/.cfg
```

Define the alias in the current shell scope:

```bash
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
```

Checkout the actual content from the bare repository to your `$HOME`:

```bash
config checkout
```

The step above might fail with a message like:

```bash
error: The following untracked working tree files would be overwritten by checkout:
    .bashrc
    .gitignore
Please move or remove them before you can switch branches.
Aborting
```

This is because your `$HOME` folder might already have some stock configuration files which would be overwritten by Git. The solution is simple: back up the files if you care about them, remove them if you don't care. A rough shortcut to move all the offending files automatically to a backup folder:

```bash
mkdir -p .config-backup && \
config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
xargs -I{} mv {} .config-backup/{}
```

Re-run the check out if you had problems:

```bash
config checkout
```

Set the flag `showUntrackedFiles` to `no` on this specific (local) repository:

```bash
config config --local status.showUntrackedFiles no
```

### Usage

After you've executed the setup any file within the `$HOME` folder can be versioned with normal commands, replacing `git` with your newly created `config` alias, like:

```bash
config status
config add .vimrc
config commit -m "Add vimrc"
config add .bashrc
config commit -m "Add bashrc"
config push
```

## System Setup

### Workspace

Use a case-sensitive disk image to avoid having to reformat a case-unsensitive system:

1. Open Disk Utility.app
2. File → New Image → Blank image...
3. Name it "_workspace_" in you home directory with these settings:
   1. Format: _APFS (case-sensitive) _
   2. Partitions: _Single Partition - GUID Partition Map_
   3. Image Format: \_sparse bundle disk image
4. Open Automator.app and create a new application
5. Add a "Run Shell Script" action with these contents: `hdiutil attach ~/workspace.dmg.sparsebundle -mountpoint ~/workspace`
6. Save the application and add it to your Login Items in System Settings.

The workspace should now be mounted on system boot at `~/workspace`

Put your projects there, for example:

```
workspace/
├── archive/      # Archived projects and legacy code
├── oss/          # Open source software projects
├── projects/     # Current active projects
└── resources/    # Shared resources and reference materials
```

Add a `.gitconfig`` file for workspace-specific rules (like maintenance).

### Finder

#### Markdown Quick Look

```
brew install --cask qlmarkdown
```

### Shell startup files

Three files, split by sync scope and shell phase:

| File | Tracked? | Runs in | Holds |
|------|----------|---------|-------|
| `~/.zprofile` | no (device-local) | login shells | PATH-only env: `brew shellenv`, `pyenv init --path`, `PNPM_HOME`, `BUN_INSTALL`, `NVM_DIR` |
| `~/.zshrc` | yes (synced via `config` alias) | interactive shells | Cross-device aliases, completions, ssh-agent bootstrap. Early-returns for non-interactive shells. Sources `~/.zshrc.local` for per-device extras |
| `~/.zshrc.local` | no (device-local) | interactive shells | Tokens + interactive init for device-specific tools: `pyenv init -`, `pyenv virtualenv-init -`, `nvm.sh`, bun completion |

Why the split:
- **Per-device vs synced.** Tools like pyenv/nvm/bun aren't installed on every machine, so their init can't sit in the tracked `~/.zshrc`.
- **Login vs interactive.** `.zprofile` runs once per login shell; `.zshrc` runs for every interactive shell. PATH setup goes in `.zprofile`; shell functions, hooks, and completions go in `.zshrc`/`.zshrc.local`.
- **Why pyenv init is split.** `pyenv init --path` (PATH-only) is in `.zprofile`. The interactive `pyenv init -` and `pyenv virtualenv-init -` live in `.zshrc.local`. If the interactive hooks fire in non-interactive shells — e.g. tmux-resurrect restoring 20 sessions at reboot — they all race for the `~/.pyenv/shims/.pyenv-shim` rehash lock and one stale leftover blocks every future shell with `pyenv: cannot rehash`. Manual recovery: `rm ~/.pyenv/shims/.pyenv-shim`.

### Ghostty + tmux: Persistent Terminal Sessions

Claude Code sessions survive Ghostty restarts and reboots via Ghostty + tmux + tmux-resurrect.

**Files:**
- `~/.config/ghostty/config` — keybindings and shell command
- `~/.config/ghostty/persist.sh` — session attach/create logic run on every new tab
- `~/.tmux.conf` — tmux config with plugin setup and Ghostty keybind targets

**How it works:**
- Every Ghostty tab runs `persist.sh` instead of a plain shell
- `persist.sh` attaches to the next free named tmux session (`claude_1`..`claude_20`), or creates one
- tmux-continuum auto-saves session layout every 15 min and auto-restores on tmux server start (after reboot)
- Ghostty keybinds route through the tmux prefix (`Ctrl+B`) so they work even with Claude Code in the foreground

**Keybindings:**

| Key | Action |
|-----|--------|
| `Cmd+T` | New tab → attach to next free session |
| `Cmd+W` | Kill current session and close tab |
| `Cmd+S` | Manually save session layout |
| `Cmd+Shift+T` | Manually restore saved sessions |

**Fresh machine setup:**
1. Clone dotfiles (see Installation above)
2. Install Ghostty and Homebrew tmux: `brew install tmux`
3. Start tmux once: `tmux` — TPM will auto-clone and install all plugins, then exit

## Credits

[Dotfiles: Best way to store in a bare git repository](https://www.atlassian.com/git/tutorials/dotfiles)
