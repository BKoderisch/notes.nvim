local M = {}

local function is_existing_dir(path)
  return vim.fn.isdirectory(path) == 1
end

local function is_contained_in_list(list, entry)
  for _, line in ipairs(list) do
    if string.find(line, entry, 1, true) then
      return true
    end
  end
  return false
end

function M.add_to_git_exclude_file(git_root_path, entry)
  local path = git_root_path .. "/.git/info/exclude"
  path = path:gsub("%s+$", "")
  if vim.fn.filereadable(path) == 1 then
    local lines = vim.fn.readfile(path)
    if not is_contained_in_list(lines, entry) then
      vim.fn.writefile({ entry }, path, "a")
    end
  end
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
