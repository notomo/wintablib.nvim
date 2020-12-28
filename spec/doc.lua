vim.o.runtimepath = vim.fn.getcwd() .. "," .. vim.o.runtimepath

local gen = function()
  require("genvdoc").generate("wintablib.nvim", {
    chapters = {
      {
        name = "LUA-MODULE",
        filter = function(node)
          return node.declaration ~= nil and node.declaration.module ~= nil
        end,
      },
    },
  })
end

gen()
