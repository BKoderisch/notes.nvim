local git = require("notes.git")

local M = {}

local state = {
  floating = {
    buf = -1,
    win = -1,
  }
}
local global_notes_path = vim.fn.stdpath('data')

function M.setup()
  vim.api.nvim_create_user_command("Note", function(opts)
    if opts.args == "toggle" then
      M.toggle_window()
    elseif opts.args == "global" then
      M.toggle_global()
    else
      print("Unknown subcommand: " .. opts.args)
    end
  end, {
    nargs = 1,
  })
end

local function get_git_root()
  local path = vim.fn.expand("%:p:h")
  return git.get_git_root(path)
end

local function save_buf_to_file(buf, file)
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  vim.fn.writefile(lines, file)
end


local function create_floating_window(opts)
  opts = opts or {}
  local width = opts.width or math.floor(vim.o.columns * 0.45)
  local height = opts.height or math.floor(vim.o.lines * 0.8)

  local col = math.floor((vim.o.columns - width) / 1.1)
  local row = math.floor((vim.o.lines - height) / 2.5)

  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_buf_set_name(buf, opts.notes_path)
    vim.bo[buf].buftype = ''
    vim.bo[buf].filetype = 'markdown'

    if vim.fn.filereadable(opts.notes_path) == 1 then
      local lines = vim.fn.readfile(opts.notes_path)
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    end
  end

  -- Define window configuration
  local win_config = {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = { " " },
    noautocmd = true
  }

  -- Create the floating window
  local win = vim.api.nvim_open_win(buf, true, win_config)

  vim.api.nvim_create_autocmd("WinLeave", {
    once = true,
    callback = function()
      if vim.api.nvim_buf_is_valid(buf) then
        save_buf_to_file(buf, opts.notes_path)
      end
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
      if vim.api.nvim_buf_is_valid(buf) then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
      state.floating = { buf = -1, win = -1 }
    end,
  })

  return { buf = buf, win = win }
end

function M.toggle_window()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    local path = get_git_root()
    if path == nil then
      path = global_notes_path
    else
      git.add_to_git_exclude_file(path, "notes.txt")
    end
    state.floating = create_floating_window { buf = state.floating.buf, notes_path = path .. "/notes.txt" }
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

function M.toggle_global()
  local path = global_notes_path
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = create_floating_window { buf = state.floating.buf, notes_path = path .. "/notes.txt" }
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

return M
