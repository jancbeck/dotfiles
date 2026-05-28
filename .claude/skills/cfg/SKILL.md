---
name: cfg
description: Sync dotfiles - pull, resolve conflicts, commit changes, and push
disable-model-invocation: true
---

# Dotfiles Sync

Manage dotfiles using the bare git repo technique with the `config` alias.

The `config` alias is defined as:
```
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
```

## Skills

Skills under `~/.claude/skills/` fall into three categories:

- **Third-party skills** — tracked in the `npx skills` lockfile at `~/.agents/.skill-lock.json` (committed to dotfiles). Installed/updated via `npx skills add` from the lockfile. Their skill folders themselves are **not** committed to the dotfiles repo.
- **Custom skills** — written by the user, committed to the dotfiles repo. Before staging a new custom skill, **ask the user** to confirm they want it tracked.
- **Computer-specific skills** — left untracked, never committed.

## Workflow

### Step 1: Pull and Rebase
```bash
config pull --rebase
```

If this fails with conflicts:
- Show the user which files have conflicts
- Read the conflicted files and help resolve them
- After resolution, run `config add <file>` for each resolved file
- Continue with `config rebase --continue` or drop the stash if needed

### Step 2: Sync Lockfile Skills
If `~/.agents/.skill-lock.json` changed in the pull (or to install any missing third-party skills), run:
```bash
npx skills add
```
This installs every skill listed in the lockfile.

### Step 3: Check Status
```bash
config status
```

Show the user:
- How many commits ahead/behind of origin
- Any modified files not yet staged

### Step 3.5: Check for Untracked Files
Since `showUntrackedFiles` is disabled, manually check key directories for new files:
```bash
config ls-files --others --exclude-standard ~/.claude/skills/
```

For each untracked skill found:
- If it appears in `~/.agents/.skill-lock.json` → skip (managed by lockfile, never commit).
- Otherwise it's either a custom skill or computer-specific → **ask the user** whether to add it. Do not stage without confirmation.

Ignore: `generate-image/`

### Step 4: Show Diff
If there are unstaged changes:
```bash
config diff
```

Summarize what changed in each file concisely.

### Step 5: Commit (if changes exist)
If there are changes to commit:
1. Stage all modified tracked files: `config add -u`
2. Draft a concise commit message based on the diff
3. Commit with:
```bash
config commit -m "<commit message>"
```

### Step 6: Push
If there are commits to push:
```bash
config push
```

### Step 7: Summary
Report final status:
- Commits pushed (if any)
- Current sync state with origin
