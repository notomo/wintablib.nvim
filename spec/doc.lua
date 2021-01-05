local gen = function()
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
end

gen()
