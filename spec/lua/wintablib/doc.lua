local util = require("genvdoc.util")
local plugin_name = vim.env.PLUGIN_NAME
local full_plugin_name = plugin_name .. ".nvim"

require("genvdoc").generate("wintablib.nvim", {
  chapters = {
    {
      name = function(group)
        return "Lua module: " .. group
      end,
      group = function(node)
        if node.declaration == nil then
          return nil
        end
        return node.declaration.module
      end,
    },
  },
})

local gen_readme = function()
  local content = ([[
# %s

This plugin provides neovim lua window and tab functions.
]]):format(full_plugin_name)

  util.write("README.md", content)
end
gen_readme()
