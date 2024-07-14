local vim = vim

local M = {}

--- Close all the left tabs.
function M.close_left()
  for _ in ipairs(vim.fn.range(2, vim.fn.tabpagenr())) do
    vim.cmd.tabclose({ range = { 1 } })
  end
end

--- Close all the right tabs.
function M.close_right()
  for _ in ipairs(vim.fn.range(vim.fn.tabpagenr(), vim.fn.tabpagenr("$") - 1)) do
    vim.cmd.tabclose({ range = { vim.fn.tabpagenr("$") } })
  end
end

--- Close the current tab even if it is the last tab.
function M.close()
  if vim.fn.tabpagenr("$") == 1 then
    vim.cmd.qall()
  end
  if vim.fn.tabpagenr() == 1 then
    vim.cmd.tabclose()
  else
    vim.cmd.tabprevious()
    vim.cmd.tabclose({ range = { vim.fn.tabpagenr() + 1 } })
  end
end

--- Open a new scratch tab.
function M.scratch()
  vim.cmd.tabedit()
  vim.bo.buftype = "nofile"
  vim.bo.swapfile = false
  vim.bo.bufhidden = "wipe"
end

--- Set autocmd to activate the left tab on TabClosed event.
--- @deprecated Use 'tabclose' option.
function M.activate_left_on_closed()
  local after_tab_leave = false
  local group_name = "wintablig_activate_left"
  vim.api.nvim_create_augroup(group_name, {})
  vim.api.nvim_create_autocmd({ "TabEnter" }, {
    group = group_name,
    pattern = { "*" },
    callback = function()
      after_tab_leave = false
    end,
  })
  vim.api.nvim_create_autocmd({ "TabLeave" }, {
    group = group_name,
    pattern = { "*" },
    callback = function()
      after_tab_leave = true
    end,
  })
  vim.api.nvim_create_autocmd({ "TabClosed" }, {
    group = group_name,
    pattern = { "*" },
    callback = function(args)
      local tab_number = tonumber(args.file)
      local current = vim.fn.tabpagenr()
      if after_tab_leave and current ~= 1 and current == tab_number then
        vim.cmd.tabprevious()
      end
    end,
  })
end

return M
