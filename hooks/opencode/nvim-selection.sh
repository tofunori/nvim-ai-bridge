#!/bin/bash
# nvim-selection.sh — OpenCode wrapper with Neovim selection injection
# Prepends the current Neovim visual selection to the OpenCode session (one-shot).
#
# Usage: use this script as an alias for `opencode` in your shell.
#   alias opencode="/path/to/hooks/opencode/nvim-selection.sh"
#
# See: https://github.com/tofunori/nvim-ai-bridge#opencode

SELECTION_FILE="${NVIM_AI_SELECTION_FILE:-/tmp/nvim_selection.txt}"
TMPFILE=""

if [[ -f "$SELECTION_FILE" && -s "$SELECTION_FILE" ]]; then
    TMPFILE=$(mktemp)
    {
        echo "=== Neovim Selection ==="
        cat "$SELECTION_FILE"
        echo "=== End Selection ==="
        echo ""
    } > "$TMPFILE"
    rm -f "$SELECTION_FILE"   # one-shot: consumed after use
fi

if [[ -n "$TMPFILE" ]]; then
    # Pass selection as initial context via stdin if opencode supports it,
    # otherwise print it so the user can paste it.
    cat "$TMPFILE"
    rm -f "$TMPFILE"
fi

exec opencode "$@"
