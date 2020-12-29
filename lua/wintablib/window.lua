local M = {}

local open = function(bufnr, open_cmd)
  vim.cmd(open_cmd or "vsplit")

  local current = vim.api.nvim_get_current_win()
  local windows = vim.tbl_filter(function(win)
    return win ~= current
  end, vim.api.nvim_tabpage_list_wins(0))
  vim.api.nvim_win_set_buf(windows[1], bufnr)
end

local from_tab = function(tab_num, open_cmd)
  local num = vim.fn.tabpagenr()
  if num == tab_num or vim.fn.tabpagenr("$") < tab_num or tab_num < 1 then
    return
  end

  local window = vim.api.nvim_tabpage_get_win(vim.api.nvim_list_tabpages()[tab_num])
  local bufnr = vim.api.nvim_win_get_buf(window)

  open(bufnr, open_cmd)

  vim.cmd(tab_num .. "tabclose")
end

--- Open the left tab active window in the current tab.
--- @param default: `vsplit`
function M.from_left_tab(open_cmd)
  from_tab(vim.fn.tabpagenr() - 1, open_cmd)
end

--- Open the right tab active window in the current tab.
--- @param default: `vsplit`
function M.from_right_tab(open_cmd)
  from_tab(vim.fn.tabpagenr() + 1, open_cmd)
end

--- Open the alternative buffer in the current tab.
--- @param default: `vsplit`
function M.from_alt(open_cmd)
  local bufnr = vim.fn.bufnr("#")
  if bufnr == -1 then
    return
  end
  open(bufnr, open_cmd)
end

local to_tab = function(tab_direction)
  local windows = vim.api.nvim_tabpage_list_wins(0)
  if #windows == 1 then
    return
  end
  local window = vim.api.nvim_get_current_win()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.cmd(tab_direction .. "tabnew")
  vim.api.nvim_win_set_buf(vim.api.nvim_get_current_win(), bufnr)
  vim.api.nvim_win_close(window, true)
end

--- Move the current window to the left tab.
function M.to_left_tab()
  to_tab("-")
end

--- Move the current window to the right tab.
function M.to_right_tab()
  to_tab("")
end

--- Open the current window in the right tab.
function M.duplicate_as_right_tab()
  vim.cmd("vsplit")
  M.to_right_tab()
end

--- Close all the floating windows.
function M.close_floating()
  local windows = vim.tbl_map(function(id)
    return {id = id, config = vim.api.nvim_win_get_config(id)}
  end, vim.api.nvim_tabpage_list_wins(0))
  windows = vim.tbl_filter(function(window)
    return window.config.relative ~= ""
  end, windows)

  for _, window in ipairs(windows) do
    vim.api.nvim_win_close(window.id, false)
  end
end

return M
