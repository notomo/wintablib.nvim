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

return M
