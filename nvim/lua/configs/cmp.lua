local cmp = require "cmp"

cmp.setup({
  formatting = {
    format = function(entry, vim_item)
      -- Truncate the abbr field to 20 characters
      vim_item.abbr = string.sub(vim_item.abbr, 1, 20)

      -- Add the source name to the menu field
      vim_item.menu = "[" .. entry.source.name .. "]"

      return vim_item
    end,
  },
})
