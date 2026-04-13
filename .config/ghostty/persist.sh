#!/bin/bash
# Ghostty runs this instead of a plain shell for every new tab.
#
# On each new tab, scan named sessions claude_1..claude_20 in order:
#   - If a slot doesn't exist yet → create it (first open or post-Cmd+W)
#   - If it exists but has no attached client → attach to it
#     (picks up restored sessions after reboot + tmux-continuum restore)
# If all 20 slots are occupied, fall back to an anonymous new session.

export PATH="/opt/homebrew/bin:$PATH"

for i in {1..20}; do
  SESSION_NAME="claude_$i"

  if ! tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    tmux new-session -s "$SESSION_NAME"
    exit 0
  fi

  CLIENT_COUNT=$(tmux list-clients -t "$SESSION_NAME" 2>/dev/null | wc -l)
  if [ "$CLIENT_COUNT" -eq 0 ]; then
    tmux attach-session -t "$SESSION_NAME"
    exit 0
  fi
done

tmux new-session
