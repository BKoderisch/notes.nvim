# notes.nvim
 A Neovim plugin to write down notes

## 🔧 Installation with lazy.nvim
```lua
{
  "BKoderisch/notes.nvim",
  config = function()
    require("notes").setup()
    vim.keymap.set("n", "<leader>n", ":Note<CR>")
  end,
}

