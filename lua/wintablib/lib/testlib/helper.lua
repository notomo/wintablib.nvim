local plugin_name = vim.split((...):gsub("%.", "/"), "/", true)[1]
local helper = require("vusted.helper")

helper.root = helper.find_plugin_root(plugin_name)

helper.before_each = function() end

helper.after_each = function()
  helper.cleanup()
  helper.cleanup_loaded_modules(plugin_name)
end

helper.input = function(text)
  vim.api.nvim_put({ text }, "c", true, true)
end

local asserts = require("vusted.assert").asserts

asserts.create("tab_count"):register_eq(function()
  return vim.fn.tabpagenr("$")
end)

asserts.create("tab"):register_eq(function()
  return vim.fn.tabpagenr()
end)

asserts.create("buffer_name"):register_eq(function()
  return vim.fn.bufname("%")
end)

asserts.create("window_count"):register_eq(function()
  return vim.fn.tabpagewinnr(vim.fn.tabpagenr(), "$")
end)

asserts.create("window"):register_eq(function()
  return vim.api.nvim_get_current_win()
end)

asserts.create("cursor"):register_same(function()
  return vim.api.nvim_win_get_cursor(0)
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

return helper
