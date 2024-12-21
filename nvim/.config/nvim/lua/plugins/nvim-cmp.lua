-- overrides for nvim-cmp
-- add cmp_luasnip as dependency
return {
  {
    "hrsh7th/nvim-cmp",
    enabled=true,
    dependencies = { "saadparwaiz1/cmp_luasnip" },
    opts = function(_, opts)
      local cmp = require("cmp") -- manually added
      -- overwrite the snippet expansion from lazyvim
      opts.snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      }
      -- manually added sources
      -- lua/lazyvim/plugins/extras/coding/nvim-cmp.lua
      opts.sources = cmp.config.sources({
          { name = "lazydev" },
          { name = "nvim_lsp" },
          { name = "path" },
        }, {
          { name = "buffer" },
        })
      -- append the source of luasnip
      table.insert(opts.sources, { name = "luasnip" })
    end,
  },
} 
