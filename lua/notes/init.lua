local M = {}

local state = {
  floating = {
    buf = -1,
    win = -1,
  }
}

function M.setup()
  vim.api.nvim_create_user_command("Note", M.toggle_window, {})
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
    local notes_path = vim.fn.stdpath('data') .. '/notes.txt'
    vim.api.nvim_buf_set_name(buf, notes_path)
    vim.bo[buf].buftype = ''
    vim.bo[buf].filetype = 'markdown'

    if vim.fn.filereadable(notes_path) then
      local lines = vim.fn.readfile(notes_path)
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    end

    vim.api.nvim_create_autocmd("BufWinLeave", {
      buffer = buf,
      callback = function()
        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        vim.fn.writefile(lines, notes_path)
      end,
    })
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

  return { buf = buf, win = win }
end

function M.toggle_window()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = create_floating_window { buf = state.floating.buf }
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

return M
