local M = {}

local root, err = require("wintablib/lib/path").find_root("wintablib/*.lua")
if err ~= nil then
  error(err)
end
M.root = root

M.before_each = function()
end

M.after_each = function()
  vim.cmd("tabedit")
  vim.cmd("tabonly!")
  vim.cmd("silent! %bwipeout!")
end

M.input = function(text)
  vim.api.nvim_put({text}, "c", true, true)
end

local asserts = require("vusted.assert").asserts

asserts.create("tab_count"):register_eq(function()
  return vim.fn.tabpagenr("$")
end)

asserts.create("tab"):register_eq(function()
  return vim.fn.tabpagenr()
end)

asserts.create("window_count"):register_eq(function()
  return vim.fn.tabpagewinnr(vim.fn.tabpagenr(), "$")
end)

asserts.create("exists_pattern"):register(function(self)
  return function(_, args)
    local pattern = args[1]
    local result = vim.fn.search(pattern, "n")
    self:set_positive(("`%s` not found"):format(pattern))
    self:set_negative(("`%s` found"):format(pattern))
    return result ~= 0
  end
end)

return M
