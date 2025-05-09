# 📝 notes.nvim

A simple Neovim plugin to quickly jot down project-specific or global notes in a floating Markdown buffer.

## Features

This plugin is designed to make note-taking within Neovim fast and frictionless. When working inside a Git repository, **notes.nvim** stores your notes in a `notes.txt` file at the repository root, automatically excluding it from version control via `.git/info/exclude`. If you're not in a Git project, it falls back to a global `notes.txt` stored in your Neovim data directory (typically `~/.local/share/nvim/notes.txt`). The notes appear in a floating window with Markdown syntax highlighting, and any changes are automatically saved when the window is closed.

## Installation (with [lazy.nvim](https://github.com/folke/lazy.nvim))

```lua
{
  "BKoderisch/notes.nvim",
  config = function()
    require("notes").setup() -- required
    -- example Keymapping
    vim.keymap.set("n", "<leader>n", ":Note toggle<CR>", { desc = "Toggle project note" })
    vim.keymap.set("n", "<leader>N", ":Note global<CR>", { desc = "Toggle global note" })
  end,
}
```

## Commands

`:Note toggle` opens/closes the project notes if available, else it uses the global notes.

`:Note global` opens/closes the global notes.

