<div align="center">

<h1>nvim · ai · bridge</h1>

<p>Share your Neovim visual selection with AI coding assistants — automatically.</p>

<p>
  <img src="https://img.shields.io/badge/Neovim-%3E%3D%200.8-57A143?style=flat-square&logo=neovim&logoColor=white" alt="Neovim >= 0.8">
  <img src="https://img.shields.io/badge/Claude_Code-supported-CC785C?style=flat-square" alt="Claude Code">
  <img src="https://img.shields.io/badge/OpenCode-supported-5C7ACC?style=flat-square" alt="OpenCode">
  <img src="https://img.shields.io/badge/license-MIT-green?style=flat-square" alt="MIT License">
</p>

</div>

---

## How it works

```
Neovim visual selection (v / V / Ctrl-V)
        │
        │  CursorMoved autocmd
        ▼
/tmp/nvim_selection.txt
        │
        ├─── Claude Code ──▶  UserPromptSubmit hook injects selection → rm file
        │
        └─── OpenCode ─────▶  Shell wrapper prepends selection → rm file
```

1. You enter visual mode in Neovim and select some code or text.
2. On every cursor move, the selection is written to `/tmp/nvim_selection.txt`.
3. When you submit a prompt to your AI assistant, the selection is prepended automatically and the file is deleted (one-shot — it won't bleed into the next prompt).

---

## Requirements

- Neovim ≥ 0.8
- [Claude Code](https://claude.ai/code) and/or [OpenCode](https://opencode.ai)

---

## Installation

### Lua plugin (lazy.nvim)

```lua
{
  "tofunori/nvim-ai-bridge",
  config = function()
    require("ai-selection").setup()
  end,
}
```

### Manual

Copy `lua/ai-selection.lua` to your Neovim runtime path:

```bash
cp lua/ai-selection.lua ~/.config/nvim/lua/ai-selection.lua
```

Then in your `init.lua`:

```lua
require("ai-selection").setup()
```

---

## Setup — Claude Code

Copy the hook script:

```bash
mkdir -p ~/.claude/hooks
cp hooks/claude-code/nvim-selection.sh ~/.claude/hooks/nvim-selection.sh
chmod +x ~/.claude/hooks/nvim-selection.sh
```

Register it in `~/.claude/settings.json`:

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/nvim-selection.sh"
          }
        ]
      }
    ]
  }
}
```

**That's it.** Make a visual selection in Neovim, then type your prompt in Claude Code — the selection is injected automatically.

---

## Setup — OpenCode

Copy the wrapper script:

```bash
mkdir -p ~/.local/bin
cp hooks/opencode/nvim-selection.sh ~/.local/bin/opencode-nvim
chmod +x ~/.local/bin/opencode-nvim
```

Add an alias in your shell config (`~/.zshrc` or `~/.bashrc`):

```bash
alias opencode="~/.local/bin/opencode-nvim"
```

When you launch `opencode`, if a Neovim selection is pending it will be printed at the top of the session before OpenCode starts.

> **Note:** OpenCode has a native Neovim plugin ([opencode.nvim](https://github.com/opencodelabs/opencode.nvim)) with `go`/`goo` keybindings that send selections directly. Use this bridge if you prefer the file-based approach or want a unified workflow across both tools.

---

## Configuration

```lua
require("ai-selection").setup({
  -- Path to the shared selection file (must match the hook script)
  selection_file = '/tmp/nvim_selection.txt',

  -- Enable automatic capture on CursorMoved (disable to use manual capture only)
  enable_autocmd = true,
})
```

### Custom file path

If you change `selection_file`, set the matching env variable in your shell:

```bash
# Claude Code hook
export CLAUDE_NVIM_SELECTION_FILE="/tmp/my_selection.txt"

# OpenCode wrapper
export NVIM_AI_SELECTION_FILE="/tmp/my_selection.txt"
```

---

## User commands

| Command | Description |
|---|---|
| `:AISelectionClear` | Clear the selection file |
| `:AISelectionCapture` | Manually capture current visual selection |

---

## Visual mode support

| Mode | Behaviour |
|---|---|
| `v` (character) | Exact selection, column-trimmed |
| `V` (line) | Full lines, no column trimming |
| `Ctrl-V` (block) | Treated as character-wise |

Selections over 100 lines are truncated with a warning notification.

---

## License

MIT
