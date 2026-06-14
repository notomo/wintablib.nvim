local helper = require("ntf.helper")
local plugin_name = helper.get_module_root(...)

helper.root = helper.find_plugin_root(plugin_name)
vim.opt.packpath:prepend(vim.fs.joinpath(helper.root, "spec/.shared/packages"))
require("assertlib").register(require("ntf.assert").register)

function helper.before_each() end

function helper.after_each() end

function helper.input(text)
  vim.api.nvim_buf_set_lines(0, 0, -1, false, { text })
end

return helper
