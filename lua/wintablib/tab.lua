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
  autocmd TabClosed * lua require("wintablib.tab")._activate_left(tonumber(vim.fn.expand('<afile>')))
augroup END
]])
end

local timer = nil
local ms = 2
function M._activate_left(tab_number)
  local current = vim.fn.tabpagenr()
  if current == 1 or current ~= tab_number then
    return
  end

  if timer == nil then
    timer = vim.loop.new_timer()
  end
  timer:stop()
  timer:start(ms, 0, vim.schedule_wrap(function()
    vim.cmd("tabprevious")
  end))
end

--- Get a tabline format string.
function M.line()
  local tab_ids = vim.api.nvim_list_tabpages()
  local tabnrs = vim.fn.range(1, vim.fn.tabpagenr("$"))
  local current = vim.fn.tabpagenr()
  local titles = vim.tbl_map(function(tabnr)
    return M._line_sel(tabnr, tab_ids[tabnr], tabnr == current)
  end, tabnrs)
  return table.concat(titles, "") .. "%#TabLineFill#%T"
end

function M._line_sel(tabnr, tab_id, is_current)
  local window = vim.api.nvim_tabpage_get_win(tab_id)
  local bufnr = vim.api.nvim_win_get_buf(window)

  local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t")
  if name == "" then
    name = "NONE"
  end

  local highlight = "%#TabLine#"
  if is_current then
    highlight = "%#TabLineSel#"
  end

  local wins = vim.api.nvim_tabpage_list_wins(tab_id)
  local win_count = #wins
  local count = tostring(win_count)

  local mod = ""
  if vim.bo[bufnr].modified then
    mod = "+"
  elseif win_count == 1 then
    count = ""
  else
    local modified = vim.tbl_filter(function(win)
      local b = vim.fn.winbufnr(win)
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
