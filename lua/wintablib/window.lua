local M = {}

local open = function(bufnr, open_cmd)
  vim.cmd(open_cmd or "vsplit")

  local current = vim.api.nvim_get_current_win()
  local windows = vim
    .iter(vim.api.nvim_tabpage_list_wins(0))
    :filter(function(win)
      return win ~= current
    end)
    :totable()
  vim.api.nvim_win_set_buf(windows[1], bufnr)
  return windows[1]
end

local from_tab = function(tab_num, open_cmd)
  local num = vim.fn.tabpagenr()
  if num == tab_num or vim.fn.tabpagenr("$") < tab_num or tab_num < 1 then
    return
  end

  local window = vim.api.nvim_tabpage_get_win(vim.api.nvim_list_tabpages()[tab_num])
  local bufnr = vim.api.nvim_win_get_buf(window)

  local view = vim.api.nvim_win_call(window, function()
    return vim.fn.winsaveview()
  end)
  local new_window = open(bufnr, open_cmd)
  vim.api.nvim_win_call(new_window, function()
    vim.fn.winrestview(view)
  end)

  vim.cmd.tabclose({ range = { tab_num } })
end

--- Open the left tab active window in the current tab.
--- @param open_cmd string? default = "vsplit"
function M.from_left_tab(open_cmd)
  from_tab(vim.fn.tabpagenr() - 1, open_cmd)
end

--- Open the right tab active window in the current tab.
--- @param open_cmd string? default = "vsplit"
function M.from_right_tab(open_cmd)
  from_tab(vim.fn.tabpagenr() + 1, open_cmd)
end

--- Open the alternative buffer in the current tab.
--- @param open_cmd string? default = "vsplit"
function M.from_alt(open_cmd)
  local bufnr = vim.fn.bufnr("#")
  if bufnr == -1 then
    return
  end
  open(bufnr, open_cmd)
end

local to_tab = function(tab_new)
  local windows = vim.api.nvim_tabpage_list_wins(0)
  if #windows == 1 then
    return
  end
  local window = vim.api.nvim_get_current_win()
  local bufnr = vim.api.nvim_get_current_buf()
  local saved = vim.fn.winsaveview()

  tab_new()

  vim.api.nvim_win_set_buf(vim.api.nvim_get_current_win(), bufnr)
  vim.fn.winrestview(saved)
  vim.api.nvim_win_close(window, true)
end

--- Move the current window to the left tab.
function M.to_left_tab()
  to_tab(function()
    vim.cmd.tabnew({ range = { math.max(1, vim.fn.tabpagenr() - 1) } })
  end)
end

--- Move the current window to the right tab.
function M.to_right_tab()
  to_tab(function()
    vim.cmd.tabnew()
  end)
end

--- Open the current window in the right tab.
function M.duplicate_as_right_tab()
  vim.cmd.vsplit()
  M.to_right_tab()
end

--- Close all the floating windows.
function M.close_floating()
  local windows = vim
    .iter(vim.api.nvim_tabpage_list_wins(0))
    :map(function(id)
      return { id = id, config = vim.api.nvim_win_get_config(id) }
    end)
    :totable()
  windows = vim
    .iter(windows)
    :filter(function(window)
      return window.config.relative ~= ""
    end)
    :totable()

  for _, window in ipairs(windows) do
    vim.api.nvim_win_close(window.id, false)
  end
end

local close = function(direction)
  local targets = {}
  local count = 1
  local before = vim.api.nvim_get_current_win()
  while true do
    local wincmd = count .. direction
    local window = vim.fn.win_getid(vim.fn.winnr(wincmd))
    if window == before then
      break
    end
    table.insert(targets, window)
    count = count + 1
    before = window
  end
  for _, window in ipairs(targets) do
    vim.api.nvim_win_close(window, false)
  end
end

--- Close all the upside windows.
function M.close_upside()
  close("k")
end

--- Close all the downside windows.
function M.close_downside()
  close("j")
end

--- Close all the rightside windows.
function M.close_rightside()
  close("l")
end

--- Close all the leftside windows.
function M.close_leftside()
  close("h")
end

--- Focus on floating window.
function M.focus_on_floating()
  local window_id = vim
    .iter(vim.api.nvim_tabpage_list_wins(0))
    :filter(function(id)
      local config = vim.api.nvim_win_get_config(id)
      return config.relative ~= "" and config.focusable == true
    end)
    :next()

  if not window_id then
    return
  end

  local ok, err = pcall(vim.api.nvim_set_current_win, window_id)
  if not ok and not vim.startswith(err, "Failed to switch to window") then
    error(err)
  end
end

return M
