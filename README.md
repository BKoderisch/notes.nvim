# 📝 notes.nvim

A simple Neovim plugin to quickly jot down project-specific or global notes in a floating Markdown buffer.

## Features

- 📂 **Project notes**: Automatically stores notes in the root of your Git repository. Project notes are automatically added to `.git/info/exclude` to avoid accidentally committing the notes.
- 🌍 **Global notes**: Saves notes in your Neovim data directory (e.g., `~/.local/share/nvim/notes.txt`).
- 💾 **Auto-saving**: Notes are automatically saved when you leave the floating window.

## 📦 Installation (with [lazy.nvim](https://github.com/folke/lazy.nvim))

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

## ⚙️ Commands

`:Note toggle` Opens/Closes the project notes if available, else it uses the global notes.

`:Note global` Opens/Closes the global notes.

