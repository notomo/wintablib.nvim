local vim = vim

local M = {}

--- Close all the left tabs.
function M.close_left()
  for _ in ipairs(vim.fn.range(2, vim.fn.tabpagenr())) do
    vim.cmd("1tabclose")
  end
end

--- Close all the right tabs.
function M.close_right()
  for _ in ipairs(vim.fn.range(vim.fn.tabpagenr(), vim.fn.tabpagenr("$") - 1)) do
    vim.cmd("$tabclose")
  end
end

--- Close the current tab even if it is the last tab.
function M.close()
  if vim.fn.tabpagenr("$") == 1 then
    vim.cmd("qall")
  end
  if vim.fn.tabpagenr() == 1 then
    vim.cmd("tabclose")
  else
    vim.cmd("tabprevious")
    vim.cmd("+tabclose")
  end
end

--- Open a new scratch tab.
function M.scratch()
  vim.cmd("tabedit")
  vim.bo.buftype = "nofile"
  vim.bo.swapfile = false
end

--- Set autocmd to activate the left tab on TabClosed event.
function M.activate_left_on_closed()
  vim.cmd([[
augroup wintablib_activate_left
  autocmd!
  autocmd TabEnter * lua require("wintablib.tab")._on_enter()
  autocmd TabLeave * lua require("wintablib.tab")._on_leave()
  autocmd TabClosed * lua require("wintablib.tab")._activate_left(tonumber(vim.fn.expand('<afile>')))
augroup END
]])
end

local after_tab_leave = false
function M._on_enter()
  after_tab_leave = false
end

function M._on_leave()
  after_tab_leave = true
end

function M._activate_left(tab_number)
  local current = vim.fn.tabpagenr()
  if after_tab_leave and current ~= 1 and current == tab_number then
    vim.cmd("tabprevious")
  end
end

local api = vim.api
local fn = vim.fn
--- Get a tabline format string.
function M.line()
  local tab_ids = api.nvim_list_tabpages()
  local tabnrs = fn.range(1, fn.tabpagenr("$"))
  local current = fn.tabpagenr()
  local titles = vim.tbl_map(function(tabnr)
    return M._tab_one(tabnr, tab_ids[tabnr], tabnr == current)
  end, tabnrs)
  return table.concat(titles, "") .. "%#TabLineFill#%T"
end

function M._tab_one(tabnr, tab_id, is_current)
  local window = api.nvim_tabpage_get_win(tab_id)
  local bufnr = api.nvim_win_get_buf(window)

  local name = fn.fnamemodify(api.nvim_buf_get_name(bufnr), ":t")
  if name == "" then
    name = "[Scratch]"
  end

  local highlight = "%#TabLine#"
  if is_current then
    highlight = "%#TabLineSel#"
  end

  local wins = api.nvim_tabpage_list_wins(tab_id)
  local floating_wins = vim.tbl_filter(function(win)
    return api.nvim_win_get_config(win).relative ~= ""
  end, wins)
  local win_count = #wins - #floating_wins
  local count = tostring(win_count)

  local mod = ""
  if vim.bo[bufnr].modified then
    mod = "+"
  elseif win_count == 1 then
    count = ""
  else
    local modified = vim.tbl_filter(function(win)
      local b = api.nvim_win_get_buf(win)
      return vim.bo[b].modified
    end, wins)
    if #modified > 0 then
      mod = "(+)"
    end
  end

  local opt = count .. mod
  local label = name
  if opt ~= "" then
    label = ("%s[%s]"):format(name, opt)
  end

  return ("%%%dT%s %s %%T%%#TabLineFill#"):format(tabnr, highlight, label)
end

return M
