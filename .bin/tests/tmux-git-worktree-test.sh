#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
WORKTREE_SCRIPT="$SCRIPT_DIR/../tmux-git-worktree.sh"

expected_multi_select="--multi"
expected_delete_key="--expect \"\$FZF_KEY_DELETE\""
expected_mark_binding='--bind "${FZF_KEY_MARK}:toggle+down,${FZF_KEY_SWITCH}:clear-selection+accept"'
expected_background_delete="nohup bash -c '_gw-delete-concurrently \"\$@\"'"
expected_pull_request_picker="open-pr-worktree() ("
expected_pull_request_layout='Author: @\(.author.login // "unknown")'

for expected_text in \
  "$expected_multi_select" \
  "$expected_delete_key" \
  "$expected_mark_binding" \
  "$expected_background_delete" \
  "$expected_pull_request_picker" \
  "$expected_pull_request_layout"; do
  if ! grep -Fq -- "$expected_text" "$WORKTREE_SCRIPT"; then
    printf 'Missing worktree picker behavior: %s\n' "$expected_text" >&2
    exit 1
  fi
done

echo "tmux-git-worktree tests passed"
