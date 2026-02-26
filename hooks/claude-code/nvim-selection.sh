#!/bin/bash
# nvim-selection.sh — Claude Code UserPromptSubmit hook
# Injects the current Neovim visual selection into the prompt (one-shot).
#
# Install: add to ~/.claude/settings.json under hooks.UserPromptSubmit
# See: https://github.com/tofunori/nvim-ai-bridge#claude-code

SELECTION_FILE="${CLAUDE_NVIM_SELECTION_FILE:-/tmp/nvim_selection.txt}"

if [[ -f "$SELECTION_FILE" && -s "$SELECTION_FILE" ]]; then
    echo "=== Neovim Selection ==="
    cat "$SELECTION_FILE"
    echo "=== End Selection ==="
    rm -f "$SELECTION_FILE"   # one-shot: consumed after injection
fi
