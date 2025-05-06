local M = {}

local function is_existing_dir(path)
  return vim.fn.isdirectory(path) == 1
end

function M.get_git_root(path)
  local cmd = string.format("cd %s && git rev-parse --show-toplevel", path)
  local root_location = vim.fn.system(cmd)
  -- remove trailing newline
  root_location = root_location:gsub("%s+$", "")
  local res = is_existing_dir(root_location)
  if res then
    return root_location
  else
    return nil
  end
end

return M
